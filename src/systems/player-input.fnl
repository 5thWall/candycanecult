(import-macros {: incf : decf} :sample-macros)
(import-macros {: new-system} :lib.macros)
(local Concord (require :lib.concord))
(local vec (require :lib.vector-light))


(fn set-animation-state [animation new-state]
  (when (not= new-state animation.state)
    (set animation.state new-state)
    (set animation.frame 1)))


(new-system ;player-input
 "Handle player input"

 {:players [:player]}

 {:update
  (fn update [self dt]
    (let [player (. self.players 1)
          animation player.animation
          speed player.player.speed
          down? love.keyboard.isScancodeDown]
      (if (down? :w) (do (set-animation-state animation :north)
                         (decf player.position.y (* speed dt)))
          (down? :a) (do (set-animation-state animation :west)
                         (decf player.position.x (* speed dt)))
          (down? :s) (do (set-animation-state animation :south)
                         (incf player.position.y (* speed dt)))
          (down? :d) (do (set-animation-state animation :east)
                         (incf player.position.x (* speed dt)))
          (set-animation-state animation :idle))))

  :mousemoved
  (fn mousemoved [self mx my _dx _dy _touch?]
    (let [camera (: (self:getWorld) :getResource :camera)
          player (. self.players 1)
          px player.position.x
          py player.position.y
          theta (vec.toPolar
                 (vec.sub mx my (camera:cameraCoords px py)))]
      (set player.player.look-angle theta)))})
