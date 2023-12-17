(local Concord (require :lib.concord))
(local vec (require :lib.vector-light))
(import-macros {: new-system : with-camera : with-color} :lib.macros)


(new-system ;draw-look
 "DEBUG SYSTEM: Draw player vision ray"

 {:players [:player]}

 {:update
  (fn draw [self]
    (let [world (self:getWorld)
          camera (world:getResource :camera)
          player (. self.players 1)]

      (with-camera camera
        (let [x player.position.x
              y player.position.y
              reach player.player.reach
              theta player.player.look-angle
              (lx ly) (vec.add x y (vec.fromPolar theta reach))]
          (with-color 0 0 0 1 (love.graphics.line x y lx ly))))))})
