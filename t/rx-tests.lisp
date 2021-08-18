
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
           (ps:ps `(rx:ps-map ,*ar* alert))
           "['primary', 'success', 'danger', 'warning', 'info', 'light', 'dark'].map(alert);"))

  (assert (equal
           (ps:ps (rx:ps-map (1 2 3) alert))
           "[1, 2, 3].map(alert);"))

  (assert (equal
           (ps:ps
             `(rx:ps-map ,*ar*
                         (paren6:=> v
                                    (rx:react-dom-render
                                     (rx:react-element -alert (ps:create variant v) "Alert")
                                     (rx:doc-element v)))))
           "['primary', 'success', 'danger', 'warning', 'info', 'light', 'dark'].map((function (v) {
    return ReactDOM.render(React.createElement(Alert, { variant : v }, 'Alert'), document.getElementById(v));
}).bind(this));"))

  (assert (equal
           `(ps:ps (rx:ps-map ,*ar* #'(rx:tlambda (v)
                                                  (rx:react-dom-render
                                                   (rx:react-element -alert (ps:create variant v) "Alert")
                                                   (rx:doc-element v))) ))
           "['primary', 'success', 'danger', 'warning', 'info', 'light', 'dark'].map((function (v) {
    return ReactDOM.render(React.createElement(Alert, { variant : v }, 'Alert'), document.getElementById(v));
}).bind(this));"))

  (assert (equal 
           (ps:ps (rx:string+ "Alert" " " "red" " " "blue"))
           "['Alert', ' ', 'red', ' ', 'blue'].reduce(function (x, y) {
    return x + y;
});")))




