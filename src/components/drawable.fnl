(local Concord (require :lib.concord))

(Concord.component
 :drawable
 (fn [c image quad]
   (set c.image image)
   (set c.quad quad)))
