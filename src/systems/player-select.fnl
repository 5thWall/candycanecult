(local Concord (require :lib.concord))
(local vec (require :lib.vector-light))


(local selector (Concord.system {:pool [:player]}))

(fn selector.mousemoved [self x y dx dy _touch?]
  (let [camera (: (self:getWorld) :getResource :camera)
        player (. self.pool 1)
        px player.position.x
        py player.position.y
        theta (vec.toPolar (vec.sub x y (camera:cameraCoords px py)))]
    (set player.player.look-angle theta)))


selector
