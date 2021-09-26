
(defpackage #:rx
  (:use #:cl)
  (:local-nicknames (#:ql #:quicklisp)
                    (#:ps #:parenscript)
                    (#:p6 #:paren6)
                    (#:a #:alexandria))
  (:export #:defm
           #:js
           #:tlambda
           #:js-func
           #:ps-map
           #:ps-reduce
           #:string+
           #:upper-case-0
           #:doc-element
           #:react-element
           #:react-component
           #:react-dom-render
           #:react-bootstrap-tab*
           #:toggle-switch-fn
           #:range-fn
           #:use-state
           #:get-prop
           #:with-prop
           #:route
           #:@
           #:{}
           #:div
           #:input
           #:label
           #:span
           #:strong))

(defpackage #:rx/tests
  (:use #:cl)
  (:local-nicknames (#:ps #:parenscript)
                    (#:p6 #:paren6)
                    (#:rx #:rx))

  (:export #:run-tests))


