(local Concord (require :lib.concord))
(local vec (require :lib.vector-light))
(import-macros {: with-camera : with-color} :lib.macros)


(local draw (Concord.system {:pool [:player]}))


(fn draw.draw [self]
  (let [world (self:getWorld)
        camera (world:getResource :camera)
        player (. self.pool 1)]

    (with-camera camera
      (let [x player.position.x
            y player.position.y
            reach player.player.reach
            theta player.player.look-angle
            (lx ly) (vec.add x y (vec.fromPolar theta reach))]
        (with-color 0 0 0 1 (love.graphics.line x y lx ly))))))


draw
