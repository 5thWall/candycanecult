(local Concord (require :lib.concord))

(Concord.component
 :player
 (fn [c speed reach lx ly]
   (set c.speed (or speed 50))
   (set c.reach (or reach 96))
   (set c.look-angle (or lx 0))))
