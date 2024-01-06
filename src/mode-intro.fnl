;;;; Candy Cane Cult
;;;; Entry for the Weak Sauce Dec '23 Jam

(import-macros {: incf : decf : unless} :macros.util)
(local Concord (require :lib.concord))
(local Camera (require :lib.camera))
(local C (require :components))
(local S (require :systems))

(local new-image love.graphics.newImage)
(local nrand love.math.randomNormal)

(local max-greebles 500)
(local world-radius 2000)


(fn test-resources [world image]
  (-> (Concord.entity world)
      (: :give :drawable image)
      (: :give :resource :gumdrop)
      (: :give :position 100 100)
      (: :give :useable 64 64 :mine))
  (-> (Concord.entity world)
      (: :give :drawable image)
      (: :give :resource :gumdrop)
      (: :give :position -100 100)
      (: :give :useable 64 64 :mine))
  (-> (Concord.entity world)
      (: :give :drawable image)
      (: :give :resource :gumdrop)
      (: :give :position 100 -100)
      (: :give :useable 64 64 :mine))
  (-> (Concord.entity world)
      (: :give :drawable image)
      (: :give :resource :gumdrop)
      (: :give :position -100 -100)
      (: :give :useable 64 64 :mine)))


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
            S.select-thing
            S.action
            S.spawn-resources
            S.camera-movement
            S.draw
            S.draw-look
            S.animation)

           (local player (require :player))
           (local gumdrop (new-image "assets/gumdrop.png"))
           (local snow (new-image "assets/snow.png"))
           (local gumdrop-piece (new-image "assets/gumdrop-piece.png"))

           (local actions
                  {:noop (fn [& _] true)
                   :mine (fn [entity _args]
                           (entity:destroy)
                           (-> (world:newEntity)
                               (: :give :position entity.position.x entity.position.y)
                               (: :give :drawable gumdrop-piece)
                               (: :give :useable 64 64 :pickup)))
                   :pickup (fn [entity player]
                             (unless player.player.held
                                     (entity:remove :position)
                                     (set player.player.held entity)))
                   })

           ;; Set Greebles
           (local greebles
             (faccumulate [batch (love.graphics.newSpriteBatch snow max-greebles) _ 1 max-greebles]
               (let [gx (* world-radius (nrand))
                     gy (* world-radius (nrand))]
                 (batch:add gx gy) batch)))

           (-> (world:newEntity)
               (: :give :position 0 0)
               (: :give :drawable greebles))

           (test-resources world gumdrop)


           (-> (world:newEntity)
               (: :give :resource-spawner :gumdrop))

           (-> (world:newEntity)
               (: :give :position 0 0)
               (: :give :animation :south 1 0.25 player.animation player.sprite-sheet)
               (: :give :player))

           (local camera (Camera.new 0 0))

           (local shaders {:outline (love.graphics.newShader "shaders/outline.glsl")})

           (world:setResource :shaders shaders)
           (world:setResource :camera camera)
           (world:setResource :res-img-map { :gumdrop gumdrop })
           (world:setResource :actions actions)
           ))


 :update
 (fn update [self dt] (self.world:emit :update dt))


 :draw
 (fn draw [self]
   (love.graphics.setBackgroundColor 1 1 1)
   (self.world:emit :draw))


 :keypressed
 (fn keypressed [self key _scancode _repeat?]
   (if (= key :escape) (love.event.quit 0)))


 :mousemoved
 (fn mousemoved [self x y dx dy touch?]
   (self.world:emit :mousemoved x y dx dy touch?))


 :mousepressed
 (fn mousepressed [self x y button touch? presses]
   (self.world:emit :mousepressed x y button touch? presses))
 }
