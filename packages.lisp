
(defpackage #:rx
  (:use #:cl)
  (:local-nicknames (#:ql #:quicklisp)
                    (#:ps #:parenscript)
                    (#:p6 #:paren6))
  (:export #:tlambda
           #:fs-func#:dom-element
           #:react-element
           #:react-dom-render))

(defpackage #:rx/tests
  (:use #:cl)
  (:local-nicknames (#:rx #:rx)
                    (#:ps #:parenscript)
                    (#:p6 #:paren6))
#|
  (:export #:dom-element
           #:react-element
           #:react-dom-render)
|#  
)
