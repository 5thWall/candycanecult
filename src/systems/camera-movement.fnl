(local Concord (require :lib.concord))
(import-macros {: new-system} :macros.ecs)


(new-system ;camera-movement
 "Locks the camera on the player"

 {:pool [:player]}

 {:update
  (fn camera-movement-update [self dt]
    (let [player (. self.pool 1)
          world (self:getWorld)
          camera (world:getResource :camera)
          (width height) (love.window.getMode)
          mid-x (/ width 2)
          mid-y (/ height 2)
          off-x (/ width 5)
          off-y (/ height 5)]
      (camera:lockWindow player.position.x player.position.y
                         (- mid-x off-x) (+ mid-x off-x)
                         (- mid-y off-y) (+ mid-y off-y))))})
