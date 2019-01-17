;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |part 2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
;;widget natural (y -> Boolean)(widget->x) (x -> y) -> (listOf Widget)
;;Consumes a widget and specifications, returns a list of widgets from the widget and its children that conform to the specifications
;(define (widget-check w n fun s t) empty)

(check-expect (widget-check Cord (λ (w) (< (widget-price w) 5)) ) empty)
(check-expect (widget-check Glass (λ (w) (< (widget-price w) 7))) (list Glass))
(check-expect (widget-check Bracelet (λ (w) (< (widget-price w) 50))) (list Bracelet Beads Glass))
(check-expect (widget-check Cord (λ (w) (> (widget-quantity w) 5))) (list Cord))
(check-expect (widget-check Glass (λ (w) (> (widget-quantity w) 7))) empty)
(check-expect (widget-check Bracelet (λ (w) (> (widget-quantity w) 3))) (list Bracelet Beads Glass))
(check-expect (widget-check Cord (λ (w) (> (string-length (widget-name w)) 5))) empty)
(check-expect (widget-check Glass (λ (w) (> (string-length (widget-name w)) 3))) (list Glass))
(check-expect (widget-check Bracelet (λ (w) (> (string-length (widget-name w)) 3))) (list Bracelet Beads Glass))

(define (widget-check w fn)
  (local
    [(define (fn-for-widget w fn)
       (append (if (fn w)
                   (list w)
                   empty)
            (foldr (λ (a b) (append (fn-for-widget a fn) b)) empty (widget-parts w))))]
  (fn-for-widget w fn)))


;----------------------------------------------------------------------------------------------------------------

;;widget fn -> (listof widget)
;;Purpose: sorts the (sub)widgets according to the specified order function, fn.
;(define (sort-widgets w fn) empty)

(check-expect (sort-widgets Wire (λ (w) (identity)) )(list Wire))
(check-expect (sort-widgets Cord (λ (w pivot) (>= (widget-price pivot) (widget-price w)))) (list Cord Wire ))
(check-expect (sort-widgets Jewelry (λ (w pivot) (< (widget-quantity pivot) (widget-quantity w)))) (list Pendant Jewelry Bracelet Glass Chain Necklace Rings Beads))
(check-expect (sort-widgets Telephone (λ (w pivot) (>= (widget-price pivot) (widget-price w)))) (list Telephone Receiver Buttons Numbers Cord Wire))
    
(define (sort-widgets w fn)
  (local [
          (define (makelist w)
            (if (empty? (widget-parts w))
                (list w)
                (append (list w) (foldr (λ (a b) (append (makelist a) b) ) empty (widget-parts w)))))
          
          (define (qsort low fn)
            (cond
              [(<= (length low) 1) low]
              [else
               (local
                 [(define pivot (first low))
                  (define (greater w) (fn w pivot))
                  (define (lesser w) (not (fn w pivot)))
                  ]
                 (append
                  (qsort (filter lesser (rest low)) fn)
                  (list pivot)
                  (qsort (filter greater (rest low)) fn)))]))]
    
    (qsort (makelist w) fn)))
    

