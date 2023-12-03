(local Concord (require :lib.concord))

(Concord.component
 :animation
 (fn [c state frame speed graph image]
   (set c.state state)
   (set c.frame frame)
   (set c.speed speed)
   (set c.graph graph)
   (set c.image image)))
