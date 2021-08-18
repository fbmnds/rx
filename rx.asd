
(asdf:defsystem #:rx
  :description "Describe rx here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on
  (#:asdf
   #:quicklisp
   #:parenscript
   #:paren6)
  :components
  ((:file "packages")
   (:file "rx")
   (:module "t"
    :components
    ((:file "rx-tests")))))

