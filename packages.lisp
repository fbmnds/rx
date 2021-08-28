
(defpackage #:rx
  (:use #:cl)
  (:local-nicknames (#:ql #:quicklisp)
                    (#:ps #:parenscript)
                    (#:p6 #:paren6))
  (:export #:js
           #:tlambda
           #:js-func
           #:ps-map
           #:ps-reduce
           #:string+
           #:doc-element
           #:react-element
           #:react-dom-render
           #:react-bootstrap-tab*))

(defpackage #:rx/tests
  (:use #:cl)
  (:local-nicknames (#:ps #:parenscript)
                    (#:p6 #:paren6)
                    (#:rx #:rx))

  (:export #:run-tests))


