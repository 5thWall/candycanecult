(local Concord (require :lib.concord))
(local vec (require :lib.vector-light))
(import-macros With :macros.with)
(import-macros {: new-system} :macros.ecs)


(new-system ;draw-look
 "DEBUG SYSTEM: Draw player vision ray"

 {:players [:player]}

 {:update
  (fn draw [self]
    (let [world (self:getWorld)
          camera (world:getResource :camera)
          player (. self.players 1)]

      (With.camera camera
        (let [x player.position.x
              y player.position.y
              reach player.player.reach
              theta player.player.look-angle
              (lx ly) (vec.add x y (vec.fromPolar theta reach))]
          (With.color 0 0 0 1 (love.graphics.line x y lx ly))))))})
