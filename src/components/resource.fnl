(local Concord (require :lib.concord))

(Concord.component
 :resource
 (fn [c kind]
   (set c.kind kind)))
