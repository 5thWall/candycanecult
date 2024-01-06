(import-macros {: incf : decf} :macros.util)
(import-macros {: new-system} :macros.ecs)
(local Concord (require :lib.concord))
(local vec (require :lib.vector-light))

(local mouse-pos love.mouse.getPosition)
(local down? love.keyboard.isScancodeDown)


(fn set-animation-state [animation new-state]
  (when (not= new-state animation.state)
    (set animation.state new-state)
    (set animation.frame 1)))


(fn update-look [world player mx my]
  (let [camera (world:getResource :camera)
        px player.position.x
        py player.position.y
        theta (vec.toPolar
               (vec.sub mx my (camera:cameraCoords px py)))]
    (set player.player.look-angle theta)))


(new-system ;player-input
 "Handle player input"

 {:players [:player]}

 {:update
  (fn update [self dt]
    (let [player (. self.players 1)
          world (self:getWorld)
          animation player.animation
          speed player.player.speed]

      (fn do-move [state dir]
        (let [(mx my) (mouse-pos)]
          (set-animation-state animation state)
          (incf player.position.x (* dir.x speed dt))
          (incf player.position.y (* dir.y speed dt))
          (update-look world player mx my)))

      (if (down? :w) (do-move :north {:x 0 :y -1})
          (down? :a) (do-move :west {:x -1 :y 0})
          (down? :s) (do-move :south {:x 0 :y 1})
          (down? :d) (do-move :east {:x 1 :y 0})
          (set-animation-state animation :idle))))


  :mousemoved
  (fn mousemoved [self mx my _dx _dy _touch?]
    (let [world (self:getWorld)
          player (. self.players 1)]
      (update-look world player mx my)))


  :mousepressed
  (fn mousepressed [self _x _y button _touch? _presses]
    (let [world (self:getWorld)
          actions [:player-action :player-alt-action]
          action (or (. actions button) :noop)]
      (print (.. "doing: " action))
      (world:emit action)))})
