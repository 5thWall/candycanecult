(import-macros {: incf} :macros.util)
(import-macros With :macros.with)
(import-macros {: new-system} :macros.ecs)
(local Concord (require :lib.concord))
(local gdraw love.graphics.draw)


(fn inc-wrap [index wrap]
  (+ (% index wrap) 1))


(fn next-index [index table]
  (inc-wrap index (length table)))


(new-system ;animation
 "Updates animations according to their configuration
  and draws the animation frame"

 {:pool [:position :animation]}

 {:update
  (fn animation-update [self dt]
    (each [_ e (ipairs self.pool)]
      (let [frames (. e.animation.graph e.animation.state)
            frame (. frames e.animation.frame)]
        (incf frame.elapsed dt)
        (when (> frame.elapsed e.animation.speed)
          (let [new-frame (next-index e.animation.frame frames)]
            (set e.animation.frame new-frame))
          (set frame.elapsed 0)))))

  :draw
  (fn animation-draw [self]
    (let [world (self:getWorld)
          camera (world:getResource :camera)]
      (With.camera camera
        (each [_ e (ipairs self.pool)]
          (let [state e.animation.state
                frame e.animation.frame
                index (. e.animation.graph state frame :frame)
                quad (. e.animation.graph state frame :quad)
                image e.animation.image]
            (gdraw image quad e.position.x e.position.y 0 1 1 24 32))))))})
