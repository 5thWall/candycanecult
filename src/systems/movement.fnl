(import-macros {: incf} :sample-macros)
(local Concord (require :lib.concord))


(local movement (Concord.system {:pool [:position :velocity]}))


(fn movement.update [self dt]
  (each [_ e (ipairs self.pool)]
    (incf e.position.x (* e.velocity.x dt))
    (incf e.position.y (* e.velocity.y dt))))


movement
