
(in-package #:rx/tests)

#+null
(js-func test
  (tlambda (data)
           (chain this
                  (set-state
                   (create data data)))))

;; C-c RET on opening parenthesis of (js-func
(defun test ()
  "(function (data) {
    return this.setState({ data : data });
}).bind(this);")

(defparameter *ar* '("primary" "success" "danger" "warning" "info" "light" "dark"))

(defun run-tests ()
  (assert (equal
           (ps:ps* `(rx:ps-map ,*ar* alert))
           (concatenate 'string
"['primary', 'success', 'danger', 'warning', 'info', 'light', 'dark'].map(alert);")))

  (assert (equal
           (ps:ps (rx:ps-map (1 2 3) alert))
           "[1, 2, 3].map(alert);"))

  (assert (equal
           (ps:ps*
            `(rx:ps-map ,*ar*
                        (paren6:=> v
                                   (rx:react-dom-render
                                    (rx:react-element -alert (ps:create variant v) "Alert")
                                    (rx:doc-element v)))))
"['primary', 'success', 'danger', 'warning', 'info', 'light', 'dark'].map((function (v) {
    return ReactDOM.render(React.createElement(Alert, { variant : v }, 'Alert'), document.getElementById(v));
}).bind(this));"))

  (assert (equal
           (ps:ps* `(rx:ps-map ,*ar* #'(rx:tlambda (v)
                                                   (rx:react-dom-render
                                                    (rx:react-element -alert
                                                                      (ps:create variant v)
                                                                      "Alert")
                                                    (rx:doc-element v))) ))
"['primary', 'success', 'danger', 'warning', 'info', 'light', 'dark'].map((function (v) {
    return ReactDOM.render(React.createElement(Alert, { variant : v }, 'Alert'), document.getElementById(v));
}).bind(this));"))

  (assert (equal 
           (ps:ps* `(rx:string+ "Alert" " " "red" " " "blue"))
"['Alert', ' ', 'red', ' ', 'blue'].reduce(function (x, y) {
    return x + y;
});"))

  (assert (equal
           (ps:ps (ps::lisp-raw "const [test,setTest] = useTest(0)"))
           "const [test,setTest] = useTest(0);"))

  (assert (equal
           (ps:ps* `(rx:js "const [test,setTest] = useTest(0)"))
           "const [test,setTest] = useTest(0);"))

  (assert (equal
           (progn
             (ps:defpsmacro -example ()
               `(lambda ()
                  (rx:js "const [test,setTest] = useState(0)")
                  ,(ps:ps-html (:div "{test}"))))
             (ps:ps (-example))) 
"function () {
    const [test,setTest] = useState(0);
    return '<div>{test}</div>';
};"))

  (assert (equal
           (ps:ps (rx:use-state "test" 0))
           "const [test,setTest] = React.useState(0);"))

  (assert (equal
           (ps:ps (rx:use-state "test" "0"))
           "const [test,setTest] = React.useState('0');"))

  (assert (equal
           (ps:ps (rx:use-state "test" 'false))
           "const [test,setTest] = React.useState(false);"))

  (assert (equal
           (ps:ps (rx:get-prop o 'p))
"try {
    o.p;
} catch (error) {
    null;
};"))

  (assert (equal
           (ps:ps
             (ps:var o (ps:create id 0))
             (rx:with-prop o 'id #'(lambda (x) (+ x 1))))
"var o = { id : 0 };
try {
    (function (x) {
        return x + 1;
    })(o.id);
} catch (error) {
    null;
};"))

  (assert (equal
           (ps:ps (rx:with-prop (ps:create :id 0) 'id #'(lambda (x) (+ x 1))))
"try {
    (function (x) {
        return x + 1;
    })({ 'id' : 0 }.id);
} catch (error) {
    null;
};"))

  (assert (equal
           (ps:ps (ps:let ((o (ps:create id 0)))
                    (rx:with-prop o 'id (lambda (x) (+ x 1)))))
"(function () {
    var o = { id : 0 };
    try {
        return (function (x) {
            return x + 1;
        })(o.id);
    } catch (error) {
        return null;
    };
})();")))


