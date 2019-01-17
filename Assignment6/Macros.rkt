#lang racket
(require test-engine/racket-tests)

;; #:transparent makes structures display a bit nicer
(define-struct graph (name nodes) #:transparent #:mutable)

(define-struct node (name edges) #:transparent #:mutable)

(define g0 (make-graph 'g0 empty))
(define g1 (make-graph 'g1 '(n2)))
(define g2 (make-graph 'g2 '(n0 n1)))
(define g3 (make-graph 'g3 '(n2)))

(define n0 (make-node 'n0 '(n1)))
(define n1 (make-node 'n1 '(n2)))
(define n2 (make-node 'n2 empty))
(define n3 (make-node 'n3 '(n5 n4 n6)))
(define n4 (make-node 'n4 '(n6)))
(define n5 (make-node 'n5 '(n6)))
(define n6 (make-node 'n6 '(n5 n7 n3)))
(define n7 (make-node 'n7 '(n6 n3)))


;; *******************************************************
;; you don't need to understand this part
;; just be sure you use my-eval instead of eval
(define-namespace-anchor a)
(define ns (namespace-anchor->namespace a))


(define-syntax my-eval
  (syntax-rules ()
    [(my-eval arg)
     (eval arg ns)]))
;; *******************************************************

;; some examples of Racket weirdness you will need to work around
(define x 3)
(define y 5)
(set! y 6)

;; in the interpreter, try:
;;     (set! x 10)
;;     (set! y 10)
;; first one fails, second one works
;; --> if you want a variable you can change later, will need both
;;     define and set! in your macro
;; (create z 99) could be a handy macro to define and set a variable

(define z (list y))
;          (list 6)
(set! y 8)
;; in the interpreter, try
;;        y
;;        z
;; it looks like values don't update properly.  how can we make it update properly?

(define z2 (list (quote y)))
(set! y 11)
;; what is z2?
;; it's '(y)
;; how to get back the 11?

;; how about (my-eval (first z2)) ?
;;    -> that's how we'll store lists of nodes

;;node graph -> graph
;;purpose: inserts a node into a graph and if it exists then do nothing
;(define (add-unique n g) g))

(define (add-unique n g)
  (if (member (node-name n) (graph-nodes g))
      (void)
      (set-graph-nodes! g (cons (node-name n) (graph-nodes g)))))

;;Purpose: make a new graph
(define-syntax new
  (syntax-rules (graph)
    [(new graph e1)
     (define e1 (make-graph (quote e1) empty))]))

;;Purpose: make a new node and input it into the passed in graph
(define-syntax vertex
  (syntax-rules (in)
    [(vertex n1 in g1)
     (begin
       (define n1 (make-node 'n1 empty))
       (add-unique n1 g1))]))

;;Purpose: Create an edge in a node to another node
(define-syntax edge
  (syntax-rules ()
    [(edge n0 n1)
     (if (member (node-name n1) (node-edges n0))
         void
         (set-node-edges! n0 (cons (node-name n1) (node-edges n0))))]))

;;Purpose: Create multiple directed or undirected edges between nodes
(define-syntax edges
  (syntax-rules (-> <->)
    [(edges n0 -> n1)
     (edge n0 n1)]

    [(edges n0 <-> n1)
     (begin (edge n0 n1) (edge n1 n0))]

    [(edges n0 op0 n1 op1 n2 ...)
     (begin (edges n0 op0 n1) (edges n1 op1 n2 ...))]))



;;Purpose: Checks whether there is a directed edge from one node to another

(check-expect (->? (make-node 'n0 empty) (make-node 'n1 empty))false)
(check-expect (->? (make-node 'n0 (list 'n1)) (make-node 'n1 empty))true)

(define-syntax ->?
  (syntax-rules ()
    [(->? e0 e1)
     (if (member (node-name e1) (node-edges e0))
         #t
         #f)]))

;;Purpose: Checks whether there is an undirected edge between the two given nodes

(check-expect  (<->? (make-node 'n0 empty) (make-node 'n1 empty)) false)
(check-expect  (<->? (make-node 'n0 '(n1)) (make-node 'n1 '(n0))) true)

(define-syntax <->?
  (syntax-rules ()
    [(<->? e0 e1)
     (if (and (member (node-name e1) (node-edges e0)) (member (node-name e0) (node-edges e1)))
         #t
         #f)]))

;; node node -> boolean
;;Purpose: return true if there is a path from n0 to n1 and false otherwise

(check-expect (-->? n0 n1) true)
(check-expect (-->? n2 n0) false)
(check-expect (-->? n0 n2) true)

(define (-->? e0 e1)
  (local [(define (fn-for-node n todo visited)
            (cond [(equal? (my-eval (node-name n)) (my-eval (node-name e1))) true]
                  [(member (my-eval (node-name n)) visited) (fn-for-lon todo visited)]
                  [else (fn-for-lon (append (node-edges n) todo) (cons (my-eval (node-name n)) visited))]))
          (define (fn-for-lon todo visited)
            (cond [(empty? todo) false]
                  [else (fn-for-node (my-eval (first todo))
                                     (rest todo)
                                     visited)]))]
    (fn-for-node e0 empty empty)))


;; graph -> (listof nodes)
;;Purpose: Returns a list of node reachable from any node in the graph

(check-expect (all-nodes (make-graph 'g0 empty)) empty)
(check-expect (all-nodes g3) '(n2))
(check-expect (all-nodes g2) '(n2 n1 n0))

(define (all-nodes g0)
  (local [(define (fn-for-node n todo visited)
            (if (member (node-name n) visited)
                (fn-for-lon todo visited)
                (fn-for-lon (append (node-edges n) todo) (cons (node-name n) visited))
                ))
            (define (fn-for-lon todo visited)
              (cond [(empty? todo) visited]
                    [else (fn-for-node (my-eval (first todo))
                                       (rest todo)
                                       visited)]))]

            (fn-for-lon (graph-nodes g0) empty)))

;; node node -> natural
;;Purpose: return the minimum distance it takes to travle from the first node to the second and -1 otherwise

(check-expect (distance n2 n0) -1)
(check-expect (distance n0 n1) 1)
(check-expect (distance n0 n2) 2)
(check-expect (distance n0 n0) 0)
(check-expect (distance n3 n7) 2)

(define (distance n1 n2)
  (local [(define (distance n1 acc visited)
            (cond [(equal? n1 n2) (list acc)]
                  [(member n1 visited) '()]
                  [else (fn-for-lon (node-edges n1) (add1 acc) (cons n1 visited))]))
          (define (fn-for-lon lon acc visited)
            (cond [(empty? lon) '()]
                  [else (append (distance (my-eval (first lon)) acc  visited) (fn-for-lon (rest lon) acc visited))]))]


  (if (-->? n1 n2)
      (apply min (distance n1 0 empty))
      -1)))

            (test)