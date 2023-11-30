;;;; Candy Cane Cult
;;;; Entry for the Weak Sauce Dec '23 Jam

(import-macros {: incf} :sample-macros)
(local Concord (require :lib.concord))

;;; Components
(Concord.component
 :position
 (fn [c x y]
   (set c.x (or x 0))
   (set c.y (or x 0))))

(Concord.component
 :velocity
 (fn [c x y]
   (set c.x (or x 0))
   (set c.y (or x 0))))

(Concord.component :drawable)

;;; Systems
;; Move
(local sys-move (Concord.system {:pool [:position :velocity]}))
(fn sys-move.update [self dt]
  (each [_ e (ipairs self.pool)]
    (incf e.position.x (* e.velocity.x dt))
    (incf e.position.y (* e.velocity.y dt))))

;; Draw
(local sys-draw (Concord.system {:pool [:position :drawable]}))
(fn sys-draw.draw [self]
  (each [_ e (ipairs self.pool)]
    (love.graphics.circle :fill e.position.x e.position.y 5)))

;;; Game state
{:world (Concord.world)

 ;; Callbacks
 :init (fn init [self]
         (let [world* self.world]
           ;; Add Systems
           (world*:addSystems sys-move sys-draw)

           ;; Add Entities
           (-> (Concord.entity world*)
               (: :give :position 100 100)
               (: :give :velocity 100 0)
               (: :give :drawable))

           (-> (Concord.entity world*)
               (: :give :position 50 50)
               (: :give :drawable))
           ))

 :update (fn update [self dt] (self.world:emit "update" dt))

 :draw (fn draw [self] (self.world:emit "draw"))

 :keypressed (fn keypressed [self key scancode repeat?]
               (if (= key :escape) (love.event.quit 0))
               )}
