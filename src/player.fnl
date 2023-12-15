(fn quad-map [image rows cols]
  (let [map {}
        newQuad love.graphics.newQuad
        (imgw imgh) (image:getDimensions)
        sw (/ imgw cols)
        sh (/ imgh rows)]
    (for [y 0 (- rows 1)]
      (for [x 0 (- cols 1)]
        (let [index (+ (length map) 1)
              sx (* x sw)
              sy (* y sh)]
          ;; (print (.. "make quad " index " " x "|" sx " " y "|" sy " " sw " " sh " " imgw " " imgh))
          (tset map index (newQuad sx sy sw sh imgw imgh)))))
    map))


(fn gen-anim [quad-map & frames]
  (icollect [_ v (ipairs frames)]
    {:elapsed 0 :frame v :quad (. quad-map v)}))


(local sprite-sheet (love.graphics.newImage "assets/NESW_gingerbread_man.png"))
(local quads (quad-map sprite-sheet 4 3))
(local (width height) (sprite-sheet:getDimensions))
(local walk-animation
       {
        :north (gen-anim quads 1 2 3 2)
        :east  (gen-anim quads 4 5 6 5)
        :south (gen-anim quads 7 8 9 8)
        :west  (gen-anim quads 10 11 12 11)
        :idle  [{:elapsed 0 :frame 8 :quad (. quads 8)}]
        })

{:sprite-sheet sprite-sheet
 :animation walk-animation
 : width : height}
