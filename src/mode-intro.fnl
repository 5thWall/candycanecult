;;;; Candy Cane Cult
;;;; Entry for the Weak Sauce Dec '23 Jam

(import-macros {: incf : decf} :sample-macros)


(local Concord (require :lib.concord))
(local Camera (require :lib.camera))


(local C (require :components))
(local S (require :systems))


;;; Game state
{:world (Concord.world)


 ;; Callbacks
 :init (fn init [self]
         (let [world self.world
               player (require :player)]
           (world:addSystems
            S.movement
            S.player-input
            S.spawn-resources
            S.camera-movement
            S.draw
            S.animation)

           (local player (require :player))
           (local gumdrop
                  (love.graphics.newImage "assets/gumdrop.png"))

           ;; (-> (Concord.entity world)
           ;;     (: :give :drawable gumdrop)
           ;;     (: :give :position 25 50))
           ;; (-> (Concord.entity world)
           ;;     (: :give :drawable gumdrop)
           ;;     (: :give :position 125 100))

           (-> (Concord.entity world)
               (: :give :resource-spawner :gumdrop))

           (-> (Concord.entity world)
               (: :give :position 0 0)
               (: :give :animation :south 1 0.25 player.animation player.sprite-sheet)
               (: :give :player))

           (local camera (Camera.new 0 0))

           (world:setResource :camera camera)
           (world:setResource :res-img-map { :gumdrop gumdrop })
           ))


 :update (fn update [self dt] (self.world:emit "update" dt))


 :draw (fn draw [self] (self.world:emit "draw"))


 :keypressed (fn keypressed [self key _scancode _repeat?]
               (if (= key :escape) (love.event.quit 0))
               )}
