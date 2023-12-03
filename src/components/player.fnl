(local Concord (require :lib.concord))

(Concord.component
 :player
 (fn [c speed] (set c.speed (or speed 50))))
