(import-macros {: decf} :sample-macros)
(local Concord (require :lib.concord))

(fn spawn-resource [spawner collideable world]
  (let [img (. (world:getResource :res-img-map) :gumdrop)
        kind spawner.kind
        ox spawner.ox
        oy spawner.oy
        max-x spawner.max-x
        max-y spawner.max-y]
    ;; TODO: Spawn a resource by kind away from any collideable
    (local rx (* max-x (love.math.randomNormal)))
    (local ry (* max-y (love.math.randomNormal)))
    (-> (Concord.entity world)
        (: :give :resource kind)
        (: :give :position rx ry)
        (: :give :drawable img))
    ))

(fn cooldown [spawner]
  (love.math.random spawner.min-cooldown spawner.max-cooldown))


(fn count-resource [resources kind]
  "Count number of resources of a kind"
  (if resources (accumulate [ct 0 _ r (ipairs resources)]
                  (if (= r.resource.kind kind) (+ ct 1) ct))
      0))

(local spawn-resources
       (Concord.system {:pool [:resource-spawner]
                        :resources [:resource :position]
                        ;; :collideable [:collideable :position]
                        }
                       ))

(fn spawn-resources.update [self dt]
  (each [_ e (ipairs self.pool)]
    (let [spawner e.resource-spawner]
      (decf spawner.cooldown dt)
      (when (<= spawner.cooldown 0)
        (set spawner.cooldown (cooldown spawner))
        (local res-count (count-resource self.resources spawner.kind))
        (if (< res-count spawner.resource-limit)
            (spawn-resource spawner self.collideable (self:getWorld)))))))

spawn-resources
