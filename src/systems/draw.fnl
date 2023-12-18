(local Concord (require :lib.concord))
(import-macros With :macros.with)
(import-macros {: new-system} :macros.ecs)


(fn get-img [world image]
  (world:getResource image))


(fn draw-image [entity]
  (let [pos entity.position
        image entity.drawable.image
        quad entity.drawable.quad]
    (if quad (let [img (get-img (entity:getWorld) image)]
               (love.graphics.draw img quad pos.x pos.y))
        (love.graphics.draw image pos.x pos.y))))


(fn draw-circle [pos]
  (love.graphics.circle :fill pos.x pos.y 5))


(fn draw-entity [entity]
  (if (?. entity.drawable :image)
      (draw-image entity)
      (draw-circle entity.position)))


(new-system ;draw
 {:pool [:position :drawable]}

 {:draw
  (fn draw [self]
    (let [world (self:getWorld)
          camera (world:getResource :camera)
          shader (. (world:getResource :shaders) :outline)]
      (With.camera camera
        (each [_ e (ipairs self.pool)]
          (draw-entity e)
          (when (?. e :useable :selected)
            (With.shader shader
              (shader:send "stepSize" [(/ 3 e.useable.width)
                                       (/ 3 e.useable.height)])
              (draw-entity e)))))))})
