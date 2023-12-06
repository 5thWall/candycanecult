(local Concord (require :lib.concord))


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


(local draw (Concord.system {:pool [:position :drawable]}))


(fn draw.draw [self]
  (let [camera (: (self:getWorld) :getResource :camera)]
    (camera:attach)
    (each [_ e (ipairs self.pool)] (draw-entity e))
    (camera:detach)))


draw
