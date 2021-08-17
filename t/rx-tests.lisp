
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

(defparameter ar '("primary" "success" "danger" "warning" "info" "light" "dark"))

(assert (equal
         (ps:ps (ps-map ar alert))
         "['primary', 'success', 'danger', 'warning', 'info', 'light', 'dark'].map(alert);"))

(assert (equal
         (ps:ps (ps-map (1 2 3) alert))
         "[1, 2, 3].map(alert);"))

(assert (equal
         (ps:ps
           (ps-map ar
                   (paren6:=> v
                              (react-dom-render
                               (react-element -alert (ps:create variant v) "Alert")
                               (doc-element v)))))
         "['primary', 'success', 'danger', 'warning', 'info', 'light', 'dark'].map((function (v) {
    return ReactDOM.render(React.createElement(Alert, { variant : v }, 'Alert'), document.getElementById(v));
}).bind(this));"))

(assert (equal
         (ps:ps (ps-map ar #'(tlambda (v)
         (react-dom-render
          (react-element -alert (ps:create variant v) "Alert")
          (doc-element v))) ))
         "['primary', 'success', 'danger', 'warning', 'info', 'light', 'dark'].map((function (v) {
    return ReactDOM.render(React.createElement(Alert, { variant : v }, 'Alert'), document.getElementById(v));
}).bind(this));"))





