;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |part 3|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define-struct widget(name quantity time price parts))
;; a widget is a (make-widget String Natural Natural Number ListOfWidget)

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
#;
(define (fn-for-fun a)
  (local
    [(define (fn-for-widget w)
       (... (widget-name w)
            (widget-quantity w)
            (widget-time w)
            (widget-price w)
            (fn-for-ListOfWidgets (widget-parts w))))

     (define (fn-for-ListOfWidgets low)
       (cond [(empty? low) (...)]
             [else (... (fn-for-widget (first low)) (fn-for-ListOfWidgets (rest low)))]))]

    (fn-for-widget a)))

(define TEXT-SIZE 24)    
(define TEXT-COLOR "black")  ;; not sure if i should have this???  maybe good for testing???
(define TAB 5) ; someone senior told me this constant might help

;; trying it with ISL-lambda rather than BSL (just don't tell the boss)
;; Natural -> String
;; creates a blank string of length equal to n
(define (blanks n)
  (list->string (build-list n (lambda (x) #\ ))))

(check-expect (blanks 0) "")
(check-expect (blanks TAB) "     ")

;;widget-> imgage
;;It produces a simple (image-based) textual representation of the hierarchy of widgets.
;;It should look something like the above example.
;(define (simple-render w) (square 1 "solid" "white"))

(check-expect (simple-render Wire) (text "Wire : 3 @ $5" TEXT-SIZE TEXT-COLOR))
(check-expect (simple-render Cord) (text (string-append "Cord : 7 @ $5\n" (blanks TAB) "Wire : 3 @ $5") TEXT-SIZE TEXT-COLOR))

;template taken from widget

(define (simple-render w)
  (local [(define (makeString w n)
            (string-append (blanks (* TAB n)) (widget-name w) " : "
                           (number->string (widget-quantity w)) " @ $" (number->string (widget-price w)) (makeString-helper (widget-parts w) (add1 n))))
          (define (makeString-helper low n)
            (cond [(empty? low) ""]
                  [else (string-append "\n" (makeString (first low) n) (makeString-helper (rest low) n))]))]
    (text (makeString w 0) TEXT-SIZE TEXT-COLOR)))

;;widget fn -> image
;;Generates a tree like simple render, but colors the text according to the function passed in.
;(define (render w fn) (square 1 "solid" "white"))
(check-expect (render Wire (λ (w) (if (> (widget-price w) 0) "Yellow" TEXT-COLOR))) (text "Wire : 3 @ $5" TEXT-SIZE "Yellow"))
(check-expect (render Beads (λ (w) (if (> (widget-quantity w) 20) "Red" TEXT-COLOR))) (above/align "left"
                                                                                                   (text "Beads : 25 @ $7" TEXT-SIZE "Red")
                                                                                                   (text "     Glass : 6 @ $4" TEXT-SIZE TEXT-COLOR)))
(check-expect (render Necklace (λ (w)
                                 (cond [(< (widget-quantity w) 5) "Red"]
                                       [(< (widget-quantity w) 10) "Yellow"]
                                       [else TEXT-COLOR])))
              (above/align "left" (text "Necklace : 10 @ $3" TEXT-SIZE TEXT-COLOR)
                           (text "     Chain : 7 @ $1" TEXT-SIZE "Yellow")
                           (text "     Pendant : 4 @ $1" TEXT-SIZE "Red")))

;template taken from widget
(define (render w fn)
  (local
    [(define (makeString w n fn)
       (above/align "left" (text (string-append (blanks (* TAB n)) (widget-name w) " : "
                                   (number->string (widget-quantity w)) " @ $" (number->string (widget-price w))) TEXT-SIZE (fn w)) (makeString-helper (widget-parts w) (add1 n) fn)))
     (define (makeString-helper low n fn)
       (cond [(empty? low) (square 0 "solid" "white")]
             [else (above/align "left" (makeString (first low) n fn) (makeString-helper (rest low) n fn))]))]


     (makeString w 0 fn)))

;;widget-> imgage
;;It produces a simple (image-based) textual representation of the hierarchy of widgets.
;;It should look something like the above example.
;(define (simple-render w) (square 1 "solid" "white"))

(check-expect (simple-render2 Wire) (text "Wire : 3 @ $5" TEXT-SIZE TEXT-COLOR))
(check-expect (simple-render2 Cord) (text (string-append "Cord : 7 @ $5\n" (blanks TAB) "Wire : 3 @ $5") TEXT-SIZE TEXT-COLOR))

;template taken from widget

(define (simple-render2 w)
  (render w (λ (w) TEXT-COLOR)))