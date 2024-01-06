(import-macros {: new-system} :macros.ecs)
(local Concord (require :lib.concord))

(new-system ;use-item
 "Player takes an action"

 {:items [:useable]
  :players [:player]}

 {:player-action ;; Why shouldn't this just be mousepressed?
  (fn player-action [self]
    (let [player (. self.players 1)
          world (self:getWorld)
          actions (world:getResource :actions)]
      (each [_ item (ipairs self.items)]
        (when item.useable.selected
          ((. actions item.useable.action) item player)))))})
