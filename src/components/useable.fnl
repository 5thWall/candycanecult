(local Concord (require :lib.concord))

(Concord.component
 :useable
 (fn [c width height action selected]
   (assert width)
   (assert height)
   (set c.width width)
   (set c.height height)
   (set c.action (or action :noop))
   (set c.selected (or selected false))))
