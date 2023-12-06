(import-macros {: incf} :sample-macros)
(local Concord (require :lib.concord))


(fn inc-wrap [index wrap]
  (+ (% index wrap) 1))


(fn next-index [index table]
  (inc-wrap index (length table)))


(local animation (Concord.system {:pool [:position :animation]}))


(fn animation.update [self dt]
  (each [_ e (ipairs self.pool)]
    (let [frames (. e.animation.graph e.animation.state)
          frame (. frames e.animation.frame)]
      (incf frame.elapsed dt)
      (when (> frame.elapsed e.animation.speed)
        (let [new-frame (next-index e.animation.frame frames)]
          (set e.animation.frame new-frame))
        (set frame.elapsed 0)))))


(fn animation.draw [self]
  (let [camera (: (self:getWorld) :getResource :camera)
        gdraw love.graphics.draw]
    (camera:attach)
    (each [_ e (ipairs self.pool)]
      (let [state e.animation.state
            frame e.animation.frame
            index (. e.animation.graph state frame :frame)
            quad (. e.animation.graph state frame :quad)
            image e.animation.image]
        (gdraw image quad e.position.x e.position.y 0 1 1 24 32)))
    (camera:detach)))


animation
