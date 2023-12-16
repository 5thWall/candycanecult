(local Concord (require :lib.concord))
(local vec (require :lib.vector-light))
(local (min max) (values math.min math.max))


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


;; (fn closer? [e1 e2 player])


(local select-thing (Concord.system {:pool [:useable :position]
                                     :players [:player]}))


(fn select-thing.update [self dt]
  (let [player (. self.players 1)]
    ;; (var selected)
    (each [_ e (ipairs self.pool)]
      (set e.useable.selected false)
      (when (intersects? e player)
        (set e.useable.selected true)))))


select-thing
