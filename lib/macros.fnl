(fn with-camera [camera & body]
  `(do (: ,camera :attach)
       ,body
       (: ,camera :detach)))


(fn with-color [r g b a & body]
  `(let [(r# g# b# a#) (love.graphics.getColor)]
     (love.graphics.setColor ,r ,g ,b ,a)
     ,body
     (love.graphics.setColor r# g# b# a#)))


(fn with-shader [shader & body]
  `(do (love.graphics.setShader ,shader)
       ,body
       (love.graphics.setShader)))


(fn new-system [& rgs]
  (var (doc query fns) (values nil nil nil))
  (if (= (length rgs) 3)
      (set (doc query fns) (unpack rgs))
      (set (query fns) (unpack rgs)))

  '(let [sys# (Concord.system ,query)]
     ,(if doc '(tset sys# :doc ,doc))
     (each [fname# fbody# (pairs ,fns)]
       (tset sys# fname# fbody#)) sys#))


;; Exports
{: with-camera : with-color : with-shader
 : new-system}
