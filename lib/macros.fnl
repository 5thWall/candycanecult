(fn with-camera [camera & body]
  `(do (: ,camera :attach)
       (do ,(unpack body))
       (: ,camera :detach)))


(fn with-color [r g b a & body]
  `(let [(r# g# b# a#) (love.graphics.getColor)]
     (love.graphics.setColor ,r ,g ,b ,a)
     (do ,(unpack body))
     (love.graphics.setColor r# g# b# a#)))


(fn with-shader [shader & body]
  `(do (love.graphics.setShader ,shader)
       (do ,(unpack body))
       (love.graphics.setShader)))


{: with-camera : with-color : with-shader}
