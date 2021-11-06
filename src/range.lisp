
(in-package :rx)


(defm range-fn ()
  `(progn
     (defun get-percentage (current min max)
       (* 100 (/ (- current min) (- max min))))
     (defun get-value (percentage min max)
       (+ min (* percentage (/ (- max min) 100))))
     (defun get-left (percentage)
       (rx:js "`calc(${percentage}% - 5px)`"))
     (defun get-width (percentage)
       (rx:js "`${percentage}%`"))
     (defun format-fn (props n)
       (when (= (ps:typeof n) "number")
         (if (rx:@ props format-fn)
             ((rx:@ props format-fn) n)
             (ps:chain n (to-fixed 0)))))
     (defun on-change (props v)
       (if (rx:@ props on-change)
           ((rx:@ props on-change) v)
           ((ps:@ console log) v)))
     (defun -range (props)
       (let* ((min@ (or (rx:@ props min) 0))
              (max@ (or (rx:@ props max) 100))
              (initial@ (or (rx:@ props initial) (/ (- max@ min@) 2)))
              (initial-percentage
                (get-percentage initial@ min@ max@))
              (range-ref ((ps:@ -react use-ref)))
              (range-progress-ref ((ps:@ -react use-ref)))
              (thumb-ref ((ps:@ -react use-ref)))
              (current-ref ((ps:@ -react use-ref)))
              (diff ((ps:@ -react use-ref)))
              (handle-update
                ((ps:@ -react use-callback)
                 (lambda (v p)
                   (setf (ps:@ thumb-ref current style left)
                         (get-left p))
                   (setf (ps:@ range-progress-ref current style width)
                         (get-width p))
                   (setf (ps:@ current-ref current text-content)
                         (format-fn props v))
                   nil)
                 (ps:array (ps:@ props format-fn))))
              (handle-mouse-move
                (lambda (e)
                  (let ((new-x (- (ps:@ e client-x)
                                  (ps:@ diff current)
                                  (ps:@ (ps:chain range-ref current
                                                  (get-bounding-client-rect))
                                        left)))
                        (end (- (ps:@ range-ref current offset-width)
                                (ps:@ thumb-ref current offset-width)))
                        (start 0))
                    (when (< new-x start) (setf new-x 0))
                    (when (> new-x end) (setf new-x end))
                    (let* ((new-percentage (get-percentage new-x start end))
                           (new-value (get-value new-percentage min@ max@)))
                      (handle-update new-value new-percentage)
                      (on-change props new-value)))))
              (handle-mouse-down
                (lambda (e)
                  (setf (ps:@ diff current)
                        (- (ps:@ e client-x)
                           (ps:@ (ps:chain thumb-ref current
                                           (get-bounding-client-rect))
                                 left)))
                  (ps:chain document
                            (add-event-listener "mouseup"
                                                handle-mouse-up))
                  (ps:chain document
                            (add-event-listener "mousemove"
                                                handle-mouse-move))))
              (handle-touch-move
                (lambda (e)
                  (let ((new-x (- (ps:@ e touches 0 client-x)
                                  (ps:@ diff current)
                                  (ps:@ (ps:chain range-ref current
                                                  (get-bounding-client-rect))
                                        left)))
                        (end (- (ps:@ range-ref current offset-width)
                                (ps:@ thumb-ref current offset-width)))
                        (start 0))
                    (when (< new-x start) (setf new-x 0))
                    (when (> new-x end) (setf new-x end))
                    (let* ((new-percentage (get-percentage new-x start end))
                           (new-value (get-value new-percentage min@ max@)))
                      (handle-update new-value new-percentage)
                      (on-change props new-value)))))
              (handle-touch-start
                (lambda (e)
                  (setf (ps:@ diff current)
                        (- (ps:@ e touches 0 client-x)
                           (ps:@ (ps:chain thumb-ref current
                                           (get-bounding-client-rect))
                                 left)))
                  (ps:chain document
                            (add-event-listener "touchend"
                                                handle-touch-end))
                  (ps:chain document
                            (add-event-listener "touchmove"
                                                handle-touch-move)))))
         (rx:js "
const handleMouseUp = () => {
    document.removeEventListener('mouseup', handleMouseUp);
    document.removeEventListener('mousemove', handleMouseMove);
  };")
         (rx:js "
const handleTouchEnd = () => {
    document.removeEventListener('touchend', handleTouchEnd);
    document.removeEventListener('touchmove', handleTouchMove);
  };")
         (ps:chain -react
                   (use-layout-effect
                    (lambda () (handle-update initial@ initial-percentage))
                    (ps:[] initial@ initial-percentage handle-update)))
         (rx:div nil
                 (rx:div (rx:{} class-name "range-header")
                         (rx:div nil (format-fn props min@))
                         (rx:div nil
                                 (rx:strong (rx:{} ref current-ref))
                                 " / "
                                 (format-fn props max@)))
                 (rx:div (rx:{} class-name "styled-range" ref range-ref)
                         (rx:div (rx:{} class-name "styled-range-progress"
                                        ref range-progress-ref))
                         (rx:div (rx:{} class-name "styled-thumb"
                                        ref thumb-ref
                                        on-mouse-down handle-mouse-down
                                        on-touch-start handle-touch-start))))))))



