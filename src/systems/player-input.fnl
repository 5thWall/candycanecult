(import-macros {: incf : decf} :sample-macros)
(local Concord (require :lib.concord))


(fn set-animation-state [animation new-state]
  (when (not= new-state animation.state)
    (set animation.state new-state)
    (set animation.frame 1)))


(local player-input (Concord.system {:pool [:player]}))


(fn player-input.update [self dt]
  (let [player (. self.pool 1)
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


player-input
