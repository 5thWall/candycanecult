;;;; Utility Macros

;; https://gitlab.com/alexjgriffith/min-love2d-fennel
(fn incf [value ?by]
  `(set ,value (+ ,value ,(or ?by 1))))


;; https://gitlab.com/alexjgriffith/min-love2d-fennel
(fn decf [value ?by]
  `(set ,value (- ,value ,(or ?by 1))))


;; https://gitlab.com/alexjgriffith/min-love2d-fennel
(fn with [t keys ?body]
  `(let [,keys ,t]
     (if ,?body
         ,?body
         ,keys)))


(fn unless [cond & body]
  `(when (not ,cond) ,body))

{: incf : decf : with : unless}
