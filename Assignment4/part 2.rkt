;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |part 2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;(require racket/list)
(require 2htdp/image)

;;Constants
(define TEXT-SIZE 20)    
(define TEXT-COLOR "black") 
(define TAB 5)

;;Data Definition
(define-struct widget (name quantity price))
;; a widget is a (make-widget String Natural Number)
; same as assignment #3, except no parts component

(define-struct bst (widget left right))
;; a BST is either
;;          false, or
;;          a (make-bst widget bst bst)

(define W1 (make-widget "b" 4 4))
(define W2 (make-widget "a" 2 1 ))
(define W3 (make-widget "c" 5 3))
(define W4 (make-widget "z" 1 0))
(define W5 (make-widget "r" 3 3))
(define W6 (make-widget "y" 5 7))

(define B0 false)
(define B1 (make-bst W1 false false))
(define B2 (make-bst W2 false B1))
(define B4 (make-bst W4 false false))
(define B3 (make-bst W3 B1 B4))
(define B5 (make-bst W5 false false))

;Templates
(define (fn-for-bst bst)
  (... (fn-for-widget (bst-widget bst))
       (fn-for-bst (bst-left bst))
       (fn-for-bst (bst-right bst))))

(define (fn-for-widget w)
  (... (widget-name w)
       (widget-price w)
       (widget-quantity w)))


;; returns a random natural  between 1 and max, inclusive
;; Natural -> Natural
(define (rnd max)
  (add1 (random max)))

;; Natural Natural -> (listof widget)
;; creates a list num random widgets whose values vary between 1 and max
(define (random-widgets num max)
  (build-list num
              (lambda (dummy)
                (make-widget 
                 (number->string (rnd max))
                 (rnd max)
                 (rnd max)))))

;insert
;;(widget bst -> boolean) Widget Bst -> Bst
;; Purpose: Adds the widget to an existing binary search tree in the correct position.
;;Widgets are ordered according to the function fn.  
;(define (insert fn w bst) false)

(check-expect (insert (λ (bst w) (string>? (widget-name w) (widget-name (bst-widget bst))))
                      W2 B1) (make-bst W1 (make-bst W2 false false) false))
(check-expect (insert (λ (bst w) (string>? (widget-name w) (widget-name (bst-widget bst))))
                      W1 B0) (make-bst W1 false false))
(check-expect (insert (λ (bst w) (string>? (widget-name w) (widget-name (bst-widget bst))))
                      W4 B2) (make-bst W2 false (make-bst W1 false (make-bst W4 false false))))
(check-expect (insert  (λ (bst w) (< (widget-price w) (widget-price (bst-widget bst))))
                       W6 B5) (make-bst W5 (make-bst W6 false false) false))

;template taken from bst

(define (insert fn w bst)
  (cond [(false? bst) (make-bst w false false)]
        [(fn bst w) (make-bst (bst-widget bst) (bst-left bst) (insert fn w (bst-right bst)))]
        [(not (fn bst w)) (make-bst (bst-widget bst) (insert fn w (bst-left bst)) (bst-right bst))]))

;;insert-all
;;(x x -> boolean) (widget -> x) (listof Widget) Bst -> Bst
;;Purpose: Inserts all of the widgets into the binary search tree.
;;Values will be ordered by the function fn.
;;The function fn will be applied to part of the widget structure referred to as field.
;(define (insert-all fn field low bst) false)

(check-expect (insert-all < widget-quantity empty false) false)
(check-expect (insert-all < widget-quantity empty B1) B1)
(check-expect (insert-all < widget-quantity (list W1) false) B1)
(check-expect (insert-all < widget-quantity (list W1 W2 W3) B4) (make-bst W4
                                                                          (make-bst W1
                                                                                    (make-bst W3 false false)
                                                                                    (make-bst W2 false false)) false))
(check-expect (insert-all > widget-quantity (list W1 W2 W3) B4) (make-bst W4
                                                                          false (make-bst W1
                                                                                          (make-bst W2 false false)   (make-bst W3 false false))))
                                                                
;template taken from bst

(define (insert-all fn field low bst)
  (local [(define (insert2 w bst)
            (insert (λ (b w) (fn (field w) (field (bst-widget b)))) w bst))]
 
    (foldl insert2 bst low)))

;find
;;(bst value -> boolean) (bst value -> boolean) value bst -> widget | false
;;Purpose: Searches a binary search tree for value based off of eq and lt.
;;eq determins if the values are equal
;;lt determins if the first value is less than the second value
;(define (find eq lt value bst) false)

(check-expect (find (λ (bst v) (string=? (widget-name (bst-widget bst)) v))
                    (λ (bst v) (string<? v (widget-name (bst-widget bst))))
                    "a" B1) false)
(check-expect (find (λ (bst v) (string=? (widget-name (bst-widget bst)) v))
                    (λ (bst v) (string<? v (widget-name (bst-widget bst))))
                    "a" B2) W2)
(check-expect (find (λ (bst v) (string=? (widget-name (bst-widget bst)) v))
                    (λ (bst v) (string<? v (widget-name (bst-widget bst))))
                    "b" B2) W1)
(check-expect (find (λ (bst v) (string=? (widget-name (bst-widget bst)) v))
                    (λ (bst v) (string<? v (widget-name (bst-widget bst))))
                    "b" B3) W1)
(check-expect (find (λ (bst v) (= (widget-price (bst-widget bst)) v))
                    (λ (bst v) (< v (widget-price (bst-widget bst))))
                    3 B5) W5)

;template taken from bst

(define (find eq lt value bst)
  (cond [(false? bst) false]
        [(eq bst value) (bst-widget bst)]
        [(lt bst value) (find eq lt value (bst-left bst))]
        [(not (lt bst value)) (find eq lt value (bst-right bst))]))

;; here is some code related to displaying a tree
;; you might find it helpful for debugging
;; (render bst) -> image


;; helper functions, can ignore
(define (blanks n)
  (list->string (build-list n (lambda (x) #\ ))))

(define (to-text side w t)
  (text  (string-append (blanks t) side (widget-name w)) TEXT-SIZE TEXT-COLOR))

(define (render-helper b t img side)
  (if (false? b)
      img
      (above/align "left"
                   (to-text side (bst-widget b) t)
                   (render-helper (bst-left b) (+ t TAB) img "L: ")
                   (render-helper (bst-right b) (+ t TAB) img "R: "))))
;; end of helper functio

;; render:  BST -> image
;; provides a graphical representation of the tree
(define (render b)
  (render-helper b 0 (square 0 "solid" "white") "T: "))


