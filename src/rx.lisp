
(in-package #:parenscript)

(named-readtables:in-readtable :parenscript)

(define-expression-operator lisp-raw (lisp-form)
  `(ps-js:escape
    ,lisp-form))

(defun lisp-raw (x) x)

(in-package #:rx)

(defmacro defm (name args &body body)
  `(ps:defpsmacro ,name ,args ,@body))

(defm js (s)
  `(ps::lisp-raw ,s))

(defm tlambda (args &body b)
  `(ps:chain
    (lambda ,args ,@b)
    (bind this)))

(defmacro js-func (name &body body)
  (let ((code (ps:ps* `(progn ,@body))))
    `(defun ,name ()
       ,code)))

(defm react-element (&body body)
  `(ps:chain -react (create-element ,@body)))

(defm react-component (&body body)
  `(p6:defclass6 ,@body))

(defm react-dom-render (&body body)
  `(ps:chain -react-d-o-m (render ,@body)))

(defm doc-element (id)
  `(ps:chain document (get-element-by-id ,id)))

(defm react-bootstrap-tab* (tab* props &body body)
  `(react-element (ps:chain -react-bootstrap ,tab*) ,props ,@body))

(defm ps-map (a f)
  (cond ((symbolp a)
         (let ((x (eval a)))
           `(ps:chain (ps:[] ,@x) (map #',f))))
        ((listp a)
         `(ps:chain (ps:[] ,@a) (map #',f)))
        (t (error "type error in PS-MAP"))))

(defm ps-reduce (a f)
  (cond ((symbolp a)
         (let ((x (eval a)))
           `(ps:chain (ps:[] ,@x) (reduce #',f))))
        ((listp a)
         `(ps:chain (ps:[] ,@a) (reduce #',f)))
        (t (error "type error in PS-REDUCE"))))

(defm string+ (&rest ar)
  `(ps-reduce ,ar #'(lambda (x y) (+ x y))))

(defm use-state (state default)
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

(defm get-prop (o p)
  `(ps:try (ps:getprop ,o ,p) (:catch (error) nil)))

(defm @ (&rest args)
  `(ps:try (ps:@ ,@args) (:catch (error) nil)))

(defm with-prop (o p fn)
  `(ps:try (funcall ,fn (ps:getprop ,o ,p)) (:catch (error) nil)))

(defm {} (&rest args) `(ps:create ,@args))

(defun route (env-path path rc hdr body &optional ends-with)
  (when (if ends-with
            (a:ends-with-subseq path env-path)
            (a:starts-with-subseq path env-path))
    (if (pathnamep body)
        `(,rc ,hdr ,body)
        `(,rc ,hdr (,body)))))


