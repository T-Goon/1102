;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |part 1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct widget(name quantity time price parts))
;; a widget is a (make-widget String Natural Natural Number ListOfWidget)

(define (fn-for-widget w)
  (... (widget-name w)
       (widget-quantity w)
       (widget-time w)
       (widget-price w)
       (fn-for-ListOfWidgets (widget-parts w))))
#;
(define (fn-for-ListOfWidgets low)
  (cond [(empty? low) (...)]
        [else (... (fn-for-widget (first low)) (fn-for-ListOfWidgets (rest low)))]))

(define Wire (make-widget "Wire" 3 5 5 empty))
(define Cord (make-widget "Cord" 7 5 5 (list Wire)))
(define Numbers (make-widget "Numbers" 9 5 5 empty))
(define Buttons (make-widget "Buttons" 8 5 5 (list Numbers)))
(define Receiver (make-widget "Receiver" 10 5 7 empty))
(define Telephone (make-widget "Telephone" 5 20 15 (list Receiver Buttons Cord)))

(define Glass (make-widget "Glass" 6 9 4 empty))
(define Beads (make-widget "Beads" 25 12 7 (list Glass)))
(define Bracelet (make-widget "Bracelet" 5 3 5 (list Beads)))
(define Chain (make-widget "Chain" 7 2 1 empty))
(define Pendant (make-widget "Pendant" 4 3 1 empty))
(define Necklace (make-widget "Necklace" 10 7 3 (list Chain Pendant)))
(define Rings (make-widget "Rings" 15 8 11 empty))
(define Jewelry (make-widget "Jewelry set" 4 17 30 (list Rings Necklace Bracelet)))

;widget natural -> (listof widget)
;This function will examine the widget, as well as all of the subwidgets used to manufacture it, and return all whose name length is longer than the specified natural.

;(define (find-widget-name-longer-than w n) empty)
(check-expect (find-widget-name-longer-than Cord 5) empty)
(check-expect (find-widget-name-longer-than Glass 3) (list Glass))
(check-expect (find-widget-name-longer-than Bracelet 3) (list Bracelet Beads Glass))
;Template taken from widgets.
(define (find-widget-name-longer-than w n)
  (append (if (> (string-length (widget-name w)) n)
              (list w)
              empty)
          (longer-helper (widget-parts w) n)))

; listofwidget natural -> listofwidget
;take a list of widgets and produce a list of widgets with name length greater than n.
;(define (longer-helper low n) empty)
;template taken from list of widgets

(define (longer-helper low n)
  (cond
    [(empty? low)
     empty]
    [else (append (find-widget-name-longer-than (first low) n) (longer-helper (rest low) n))]))

;---------------------------------------------------------------------------------------------------------

;widget natural -> (listof widget)
;This function will examine the widget, as well as all of the subwidgets used to manufacture it, and return all whose quantity in stock is greater than the specified natural.

;(define (find-widget-quantity-over w n) empty)
(check-expect (find-widget-quantity-over Cord 5) (list Cord))
(check-expect (find-widget-quantity-over Glass 7) empty)
(check-expect (find-widget-quantity-over Bracelet 3) (list Bracelet Beads Glass))

;Template taken from widgets.
(define (find-widget-quantity-over w n)
  (append (if (> (widget-quantity w) n)
              (list w)
              empty)
          (quantity-helper (widget-parts w) n)))

; listofwidget natural -> listofwidget
;take a list of widgets and produce a list of widgets with quantity in stock greater than n.
;(define (quantity-helper low n) empty)
;template taken from list of widgets

(define (quantity-helper low n)
  (cond
    [(empty? low)
     empty]
    [else (append (find-widget-quantity-over (first low) n) (quantity-helper (rest low) n))]))

;-----------------------------------------------------------------------------------------------------------------

;widget natural -> (listof widget)
;This function will examine the widget, as well as all of the subwidgets used to manufacture it, and return all whose price is less than the specified natural.

;(define (find-widgets-cheaper-than w n) empty)
(check-expect (find-widgets-cheaper-than Cord 5) empty)
(check-expect (find-widgets-cheaper-than Glass 7) (list Glass))
(check-expect (find-widgets-cheaper-than Bracelet 50) (list Bracelet Beads Glass))

;Template taken from widgets.
(define (find-widgets-cheaper-than w n)
  (append (if (< (widget-price w) n)
              (list w)
              empty)
          (price-helper (widget-parts w) n)))

; listofwidget natural -> listofwidget
;take a list of widgets and produce a list of widgets with quantity in stock greater than n.
;(define (price-helper low n) empty)
;template taken from list of widgets

(define (price-helper low n)
  (cond
    [(empty? low)
     empty]
    [else (append (find-widgets-cheaper-than (first low) n) (price-helper (rest low) n))]))

;--------------------------------------------------------------------------------------------------------------

;;widget natura11 number2 -> (listof widget)
;;Purpose: This function will examine the widget, as well as all of the subwidgets used to manufacture it,
;;and return those whose quantity in stock is less than natural1 or whose cost is greater than number2.
;(define (find-widget-hard-make w n1 n2) empty)

(check-expect (find-widget-hard-make Cord 0 100) empty)
(check-expect (find-widget-hard-make Glass 7 3) (list Glass))
(check-expect (find-widget-hard-make Glass 7 70) (list Glass))
(check-expect (find-widget-hard-make Glass 1 3) (list Glass))
(check-expect (find-widget-hard-make Bracelet 100 0) (list Bracelet Beads Glass))

;template taken from widget

(define (find-widget-hard-make w n1 n2)
  (append (if (or-helper (widget-quantity w) (widget-price w) n1 n2)
       (list w)
       empty)
       (hard-helper (widget-parts w) n1 n2)))


;;(listof Widget) natura11 number2 -> (listof widget)
;;Purpose: return the widgets in the consumed list that have a quantity less than n1 and a cost greater than n2
;(define (cheaper-helper low n1 n2) empty)

(define (hard-helper low n1 n2)
  (cond [(empty? low) empty]
        [else (append (find-widget-hard-make (first low) n1 n2) (hard-helper (rest low) n1 n2))]))

;; number number number number -> Boolean
;;Purpose: consumes 2 pairs of numbers and checks if either number 1 < number 3 or number 2 > number 4
;(define (or-helper n1 n2 n3 n4) false)

(check-expect (or-helper 0 0 0 0) false)
(check-expect (or-helper 0 0 1 0) true)
(check-expect (or-helper 0 1 0 0) true)
(check-expect (or-helper 0 1 1 0) true)
#;
(define (or-helper n1 n2 n3 n4)
  (... n1 n2 n3 n4))

(define (or-helper n1 n2 n3 n4)
  (or (< n1 n3) (> n2 n4)))