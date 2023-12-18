;;;; Working with the ECS system

;;; Entity Creation
(fn new-system [& rgs]
  (var (doc query fns) (values nil nil nil))
  (if (= (length rgs) 3)
      (set (doc query fns) (unpack rgs))
      (set (query fns) (unpack rgs)))

  '(let [sys# (Concord.system ,query)]
     ,(if doc '(tset sys# :doc ,doc))
     (each [fname# fbody# (pairs ,fns)]
       (tset sys# fname# fbody#)) sys#))


;;; Exports
{: new-system}
