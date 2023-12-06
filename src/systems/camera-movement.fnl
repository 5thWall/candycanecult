(local Concord (require :lib.concord))

(local camera-movement (Concord.system {:pool [:player]}))

(fn camera-movement.update [self dt]
  (let [player (. self.pool 1)
        world (self:getWorld)
        camera (world:getResource :camera)
        (width height) (love.window.getMode)
        mid-x (/ width 2)
        mid-y (/ height 2)
        off-x (/ width 5)
        off-y (/ height 5)]
    ;; (print (.. (- mid-x offset) "," (+ mid-x offset) "," (- mid-y offset) "," (+ mid-y offset)))
    (camera:lockWindow player.position.x player.position.y
                 (- mid-x off-x) (+ mid-x off-x)
                 (- mid-y off-y) (+ mid-y off-y))))

camera-movement
