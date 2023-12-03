(local Concord (require :lib.concord))


(local draw (Concord.system {:pool [:position :drawable]}))


(fn draw.draw [self]
  (let [camera (: (self:getWorld) :getResource :camera)]
    (camera:attach)
    (each [_ e (ipairs self.pool)]
      (love.graphics.circle :fill e.position.x e.position.y 5))
    (camera:detach)))


draw
