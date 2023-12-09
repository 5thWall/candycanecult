(local Concord (require :lib.concord))

(Concord.component
 :resource-spawner
 (fn [c kind limit ox oy max-x max-y min-cooldown max-cooldown cooldown]
   (assert kind)
   (set c.kind kind)
   (set c.resource-limit (or limit 10))
   (set c.ox (or ox 0))
   (set c.oy (or oy 0))
   (set c.max-x (or max-x 1000))
   (set c.max-y (or max-y 1000))
   (set c.min-cooldown (or min-cooldown 5))
   (set c.max-cooldown (or max-cooldown 15))
   (set c.cooldown
        (or cooldown (love.math.random c.min-cooldown
                                       c.max-cooldown)))))
