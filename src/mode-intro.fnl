;;;; Candy Cane Cult
;;;; Entry for the Weak Sauce Dec '23 Jam

(import-macros {: incf : decf} :sample-macros)
(local Concord (require :lib.concord))
(local Camera (require :lib.camera))

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
 :animation
 (fn []))
(Concord.component
 :velocity
 (fn [c x y]
   (set c.x (or x 0))
   (set c.y (or y 0))))

(Concord.component :drawable)
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
        speed player.player.speed
        down? love.keyboard.isScancodeDown]

    (if (down? :w) (decf player.position.y (* speed dt))
        (down? :s) (incf player.position.y (* speed dt))
        (down? :a) (decf player.position.x (* speed dt))
        (down? :d) (incf player.position.x (* speed dt)))))

(local sys-cam-move (Concord.system {:pool [:player]}))
(fn sys-cam-move.update [self dt]
  "Set cam around player"
  (let [player (. self.pool 1)
        px player.position.x
        py player.position.y
        world (self:getWorld)
        camera (world:getResource :camera)
        (cx cy) (camera:position)
        dx (- px cx)
        dy (- py cy)]
    (camera:move dx dy)))

;; Draw
(local sys-draw (Concord.system {:pool [:position :drawable]}))
(fn sys-draw.draw [self]
  (let [camera (: (self:getWorld) :getResource :camera)]
    (camera:attach)
    (each [_ e (ipairs self.pool)]
      (love.graphics.circle :fill e.position.x e.position.y 5))
    (camera:detach)))

;;; Game state
{:world (Concord.world)

 ;; Callbacks
 :init (fn init [self]
         (let [world self.world]
           ;; Add Systems
           (world:addSystems
            sys-move
            sys-player-input
            sys-cam-move
            sys-draw)

           ;; Add Entities
           (-> (Concord.entity world)
               (: :give :position 100 100)
               (: :give :velocity 100 50)
               (: :give :drawable))

           (-> (Concord.entity world)
               (: :give :position 50 50)
               (: :give :drawable)
               (: :give :player))

           (local camera (Camera.new 50 50))

           (world:setResource :camera camera)
           ))

 :update (fn update [self dt] (self.world:emit "update" dt))

 :draw (fn draw [self] (self.world:emit "draw"))

 :keypressed (fn keypressed [self key scancode repeat?]
               (if (= key :escape) (love.event.quit 0))
               )}
