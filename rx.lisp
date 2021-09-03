
(in-package #:parenscript)

(named-readtables:in-readtable :parenscript)

(define-expression-operator lisp-raw (lisp-form)
  `(ps-js:escape
    ,lisp-form))

(defun lisp-raw (x) x)

(in-package #:rx)

(ps:defpsmacro js (s)
  `(ps::lisp-raw ,s))

(ps:defpsmacro tlambda (args &body b)
  `(ps:chain
    (lambda ,args ,@b)
    (bind this)))

(defmacro js-func (name &body body)
  (let ((code (ps:ps* `(progn ,@body))))
    `(defun ,name ()
       ,code)))

(ps:defpsmacro react-element (&body body)
  `(ps:chain -react (create-element ,@body)))

(ps:defpsmacro react-component (&body body)
  `(p6:defclass6 ,@body))

(ps:defpsmacro react-dom-render (&body body)
  `(ps:chain -react-d-o-m (render ,@body)))

(ps:defpsmacro doc-element (id)
  `(ps:chain document (get-element-by-id ,id)))

(ps:defpsmacro react-bootstrap-tab* (tab* props &body body)
  `(react-element (ps:chain -react-bootstrap ,tab*) ,props ,@body))

(ps:defpsmacro ps-map (a f)
  (cond ((symbolp a)
         (let ((x (eval a)))
           `(ps:chain (ps:[] ,@x) (map #',f))))
        ((listp a)
         `(ps:chain (ps:[] ,@a) (map #',f)))
        (t (error "type error in PS-MAP"))))

(ps:defpsmacro ps-reduce (a f)
  (cond ((symbolp a)
         (let ((x (eval a)))
           `(ps:chain (ps:[] ,@x) (reduce #',f))))
        ((listp a)
         `(ps:chain (ps:[] ,@a) (reduce #',f)))
        (t (error "type error in PS-REDUCE"))))

(ps:defpsmacro string+ (&rest ar)
  `(ps-reduce ,ar #'(lambda (x y) (+ x y))))

(ps:defpsmacro use-state (state default)
  (let* ((const (format nil
                        "const [~a,set~a] = React.useState"
                        state (string-capitalize state)))
         (const (cond ((numberp default) (format nil "~a(~a)" const default))
                      ((stringp default) (format nil "~a('~a')" const default))
                      ((and (listp default) (eq (car default) 'quote))
                       (format nil "~a(~a)" const (string-downcase
                                                   (symbol-name
                                                    (cadr default)))))
                      (t (error "use-state argument error")))))
    `(rx:js ,const)))

(ps:defpsmacro get-prop (o p)
  `(ps:try (ps:getprop ,o ,p) (:catch (error) ps:undefined)))

(ps:defpsmacro with-prop (o p fn)
  `(ps:try (funcall ,fn (ps:getprop ,o ,p)) (:catch (error) ps:undefined)))

(ps:defpsmacro {} (&rest args) `(ps:create ,@args))

