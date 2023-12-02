;;;; Candy Cane Cult
;;;; Entry for the Weak Sauce Dec '23 Jam

(import-macros {: incf : decf} :sample-macros)
(local Concord (require :lib.concord))
(local Camera (require :lib.camera))


;; Utilities
(fn set-animation-state [animation new-state]
  (when (not= new-state animation.state)
    (set animation.state new-state)
    (set animation.frame 1)))

(fn inc-wrap [index wrap]
  "Returns index incremented by 1 wrapped back to 1 at wrap"
  (+ (% index wrap) 1))

;;; Components
(Concord.component
 :position
 (fn [c x y]
   (set c.x (or x 0))
   (set c.y (or x 0))))


(Concord.component
 :facing
 (fn [c dir]
   (set c.dir (or dir :south))))


(Concord.component
 :velocity
 (fn [c x y]
   (set c.x (or x 0))
   (set c.y (or y 0))))


(Concord.component
 :animation
 (fn [c state frame speed graph image]
   (set c.state state)
   (set c.frame frame)
   (set c.speed speed)
   (set c.graph graph)
   (set c.image image)))


(Concord.component :drawable)

(Concord.component
 :resource
 (fn [c kind]
   (set c.kind kind)))


(Concord.component
 :player
 (fn [c speed] (set c.speed (or speed 50))))

;;; Systems
;; Move
(local sys-move (Concord.system {:pool [:position :velocity]}))

(fn sys-move.update [self dt]
  (each [_ e (ipairs self.pool)]
    (incf e.position.x (* e.velocity.x dt))
    (incf e.position.y (* e.velocity.y dt))))

(local sys-player-input (Concord.system {:pool [:player]}))

(fn sys-player-input.update [self dt]
  "Move player around"
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


(local sys-cam-move (Concord.system {:pool [:player]}))

(fn sys-cam-move.update [self dt]
  (let [player (. self.pool 1)
        world (self:getWorld)
        camera (world:getResource :camera)
        (width height) (love.window.getMode)
        mid-x (/ width 2)
        mid-y (/ height 2)
        offset 25]
    (camera:lockWindow player.position.x player.position.y
                 (- mid-x offset) (+ mid-x offset)
                 (- mid-y offset) (+ mid-y offset))))

;; Draw
(local sys-draw (Concord.system {:pool [:position :drawable]}))
(fn sys-draw.draw [self]
  (let [camera (: (self:getWorld) :getResource :camera)]
    (camera:attach)
    (each [_ e (ipairs self.pool)]
      (love.graphics.circle :fill e.position.x e.position.y 5))
    (camera:detach)))


(local sys-animation (Concord.system {:pool [:position :animation]}))

(fn sys-animation.update [self dt]
  (each [_ e (ipairs self.pool)]
    (let [frames (. e.animation.graph e.animation.state)
          frame (. frames e.animation.frame)]
      (incf frame.elapsed dt)
      (when (> frame.elapsed e.animation.speed)
        (let [new-frame (inc-wrap e.animation.frame (length frames))]
          (set e.animation.frame new-frame))
        (set frame.elapsed 0)))))

(fn sys-animation.draw [self]
  (let [camera (: (self:getWorld) :getResource :camera)
        gdraw love.graphics.draw]
    (camera:attach)
    (each [_ e (ipairs self.pool)]
      (let [state e.animation.state
            frame e.animation.frame
            index (. e.animation.graph state frame :frame)
            quad (. e.animation.graph state frame :quad)
            image e.animation.image]
        (gdraw image quad e.position.x e.position.y)))
    (camera:detach)))

;;; Game state
{:world (Concord.world)

 ;; Callbacks
 :init (fn init [self]
         (let [world self.world
               player (require :player)]
           (world:addSystems
            sys-move
            sys-player-input
            sys-cam-move
            sys-draw
            sys-animation)

           ;; (local player (require :player))

           (-> (Concord.entity world)
               (: :give :drawable)
               (: :give :position 25 50))
           (-> (Concord.entity world)
               (: :give :drawable)
               (: :give :position 125 100))

           (-> (Concord.entity world)
               (: :give :position 50 50)
               (: :give :animation :south 1 0.25 player.animation player.sprite-sheet)
               (: :give :player))

           (local camera (Camera.new 50 50))

           (world:setResource :camera camera)
           ))

 :update (fn update [self dt] (self.world:emit "update" dt))

 :draw (fn draw [self] (self.world:emit "draw"))

 :keypressed (fn keypressed [self key _scancode _repeat?]
               (if (= key :escape) (love.event.quit 0))
               )}
