(local Concord (require :lib.concord))

(Concord.component
 :position
 (fn [c x y]
   (set c.x (or x 0))
   (set c.y (or y 0))))
