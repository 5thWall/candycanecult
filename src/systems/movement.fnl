(import-macros {: incf} :sample-macros)
(import-macros {: new-system} :lib.macros)
(local Concord (require :lib.concord))


(new-system ;movement
 {:pool [:position :velocity]}

 {:update
  (fn movement-update [self dt]
    (each [_ e (ipairs self.pool)]
      (incf e.position.x (* e.velocity.x dt))
      (incf e.position.y (* e.velocity.y dt))))})
