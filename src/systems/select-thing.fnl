(local Concord (require :lib.concord))
(local vec (require :lib.vector-light))
(local (min max) (values math.min math.max))
(import-macros {: new-system} :lib.macros)


;; From aek: https://www.lexaloffle.com/bbs/?tid=39127
;; Ray intersects rec by slab method
(fn ray-in-rec? [x0 y0 x1 y1 l t r b]
  (let [tl (/ (- l x0) (- x1 x0))
        tr (/ (- r x0) (- x1 x0))
        tt (/ (- t y0) (- y1 y0))
        tb (/ (- b y0) (- y1 y0))]
    (< (max 0 (max (min tl tr) (min tt tb)))
       (min 1 (min (max tl tr) (max tt tb))))))


(fn intersects? [ent player]
  (let [px player.position.x
        py player.position.y
        (lx ly) (vec.add px py
                         (vec.fromPolar player.player.look-angle
                                        player.player.reach))
        tx ent.position.x
        ty ent.position.y
        bx (+ ent.useable.width tx)
        by (+ ent.useable.height ty)]
    (ray-in-rec? px py lx ly tx ty bx by)))


(fn closer [e1 e2 pl]
  (if (= e1 nil) e2
      (= e2 nil) e1
      (let [d1 (vec.dist2 e1.position.x e1.position.y
                          pl.position.x pl.position.y)
            d2 (vec.dist2 e2.position.x e2.position.y
                          pl.position.x pl.position.y)]
        (if (<= d1 d2) e1 e2))))

(new-system ;; select-thing
 "Mark the closest thing the player is pointing at as selected"


 {:pool [:useable :position]
  :players [:player]}


 {:update
  (fn select-thing-update [self dt]
    (let [player (. self.players 1)]
      (var selected nil)
      (each [_ e (ipairs self.pool)]
        (set e.useable.selected false)
        (when (intersects? e player)
          (set selected (closer selected e player))))
      (if selected (set selected.useable.selected true))))})
