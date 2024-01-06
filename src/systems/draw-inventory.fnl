(local Concord (require :lib.concord))
(import-macros {: new-system} :macros.ecs)

(local padding x 20)
(local padding y 20)

(new-system ;draw-inventory
 {:players [:player]}

 {:draw
  (fn draw [self]
    (let [player (. self.players 1)]
      ))})
