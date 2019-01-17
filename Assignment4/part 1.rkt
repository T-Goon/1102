;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |part 1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define B0 false)
(define B1 (make-bst W1 false false))
(define B2 (make-bst W2 false B1))
(define B4 (make-bst W4 false false))
(define B3 (make-bst W3 B1 B4))

;Templates
(define (fn-for-bst bst)
  (... (fn-for-widget (bst-widget bst))
        (fn-for-bst (bst-left bst))
        (fn-for-bst (bst-right bst))))

(define (fn-for-widget w)
  (... (widget-name w)
       (widget-price w)
       (widget-quantity w)))

;;Functions
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

;; (listof widget) bst -> bst
;; inserts all widgets in low into bst
(define (build-tree low)
  (foldr insert-name false low))

;;Widget BST -> BST
;; Adds the widget to an existing binary search tree in the correct position.
;(define (insert-name v b) b)

(check-expect (insert-name W2 B1) (make-bst W1 (make-bst W2 false false) false))
(check-expect (insert-name W1 B0) (make-bst W1 false false))
(check-expect (insert-name W4 B2) (make-bst W2 false (make-bst W1 false (make-bst W4 false false))))

;template taken from bst

(define (insert-name w bst)
  (cond [(false? bst) (make-bst w false false)]
        [(string>? (widget-name w) (widget-name (bst-widget bst))) (make-bst (bst-widget bst) (bst-left bst) (insert-name w (bst-right bst)))]
        [(string<? (widget-name w) (widget-name (bst-widget bst))) (make-bst (bst-widget bst) (insert-name w (bst-left bst)) (bst-right bst))]))


;;find-name
;;String Bst -> Widget | false
;;Purpose: Returns the widget whose name corresponds to the given string, or false if that widget does not exist
;(define (find-name str bst) false)

(check-expect (find-name "a" B1) false)
(check-expect (find-name "a" B2) W2)
(check-expect (find-name "b" B2) W1)
(check-expect (find-name "b" B3) W1)

;Templates taken from bst

(define (find-name str bst)
  (cond [(false? bst) false]
        [(string=? str (widget-name (bst-widget bst))) (bst-widget bst)]
        [(string<? str (widget-name (bst-widget bst))) (find-name str (bst-left bst))]
        [(string>? str (widget-name (bst-widget bst))) (find-name str (bst-right bst))]))
         

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


