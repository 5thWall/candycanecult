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
         (love.mouse.setGrabbed true)
         (let [world self.world
               player (require :player)]
           (world:addSystems
            S.movement
            S.player-input
            S.player-select
            S.spawn-resources
            S.camera-movement
            S.draw
            S.draw-look
            S.animation)

           (local player (require :player))
           (local gumdrop
                  (love.graphics.newImage "assets/gumdrop.png"))

           (-> (Concord.entity world)
               (: :give :drawable gumdrop)
               (: :give :position 25 50))
           (-> (Concord.entity world)
               (: :give :drawable gumdrop)
               (: :give :position 125 100))

           (-> (Concord.entity world)
               (: :give :resource-spawner :gumdrop))

           (-> (Concord.entity world)
               (: :give :position 0 0)
               (: :give :animation :south 1 0.25 player.animation player.sprite-sheet)
               (: :give :player))

           (local camera (Camera.new 0 0))

           (local shaders {:outline (love.graphics.newShader "shaders/outline.glsl")})

           (world:setResource :shaders shaders)
           (world:setResource :camera camera)
           (world:setResource :res-img-map { :gumdrop gumdrop })
           ))


 :update (fn update [self dt] (self.world:emit "update" dt))


 :draw (fn draw [self] (self.world:emit "draw"))


 :keypressed (fn keypressed [self key _scancode _repeat?]
               (if (= key :escape) (love.event.quit 0))
               )

 :mousemoved (fn mousemoved [self x y dx dy touch?]
               (self.world:emit "mousemoved" x y dx dy touch?))
 }
