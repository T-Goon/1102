;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |tic tac toe|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;Timothy Goon
;;Ashley Schuliger

(require 2htdp/image)
(require 2htdp/universe)
(require racket/list)

;; "strongly suggest" constructing a word state that has (at minimum):
;;      state of the board
;;      whose turn it is

(define SIZE 900) ;; can be between 300 and 900

;; can use this to draw the board
(define PEN (make-pen "LightSalmon" 15 "solid" "round" "round"))
(define MTS (empty-scene SIZE SIZE))
(define X (text "X" (round (/ SIZE 4)) "red"))
(define O (text "O" (round (/ SIZE 4)) "blue"))
(define rows (list (list 0 1 2)
                   (list 3 4 5)
                   (list 6 7 8)))
(define cols (list (list 0 3 6)
                   (list 1 4 7)
                   (list 2 5 8)))
(define cross (list (list 0 4 8)
                    (list 2 4 6)))
(define units (append rows cols cross))

;; one easy way to draw a line
(define BOARD (add-line
               (add-line
                (add-line
                 (add-line MTS (/ SIZE 16) (/ (* 2 SIZE) 3) (/ (* 15 SIZE) 16) (/ (* 2 SIZE) 3) PEN) ;Bottom Horizontal
                 (/ SIZE 3) (/ SIZE 16) (/ SIZE 3) (/ (* 15 SIZE) 16) PEN)                           ;Left Vertical
                (/ (* 2 SIZE) 3) (/ SIZE 16) (/ (* 2 SIZE) 3) (/ (* 15 SIZE) 16) PEN)                ;Right Vertical
               (/ SIZE 16) (/ SIZE 3) (/ (* 15 SIZE) 16) (/ SIZE 3) PEN))                            ;Top Horizontal

(define POSITIONS (list (make-posn (/ (+ (/ SIZE 3) (/ SIZE 16)) 2) (/ (+ (/ SIZE 3) (/ SIZE 16)) 2))
                        (make-posn (/ (+ (/ SIZE 3) (/ (* 2 SIZE) 3)) 2) (/ (+ (/ SIZE 3) (/ SIZE 16)) 2))
                        (make-posn (/ (+ (/ (* 15 SIZE) 16) (/ (* 2 SIZE) 3)) 2) (/ (+ (/ SIZE 3) (/ SIZE 16)) 2))
                        (make-posn (/ (+ (/ SIZE 3) (/ SIZE 16)) 2) (/ (+ (/ SIZE 3) (/ (* 2 SIZE) 3)) 2))
                        (make-posn (/ (+ (/ SIZE 3) (/ (* 2 SIZE) 3)) 2) (/ (+ (/ SIZE 3) (/ (* 2 SIZE) 3)) 2))
                        (make-posn (/ (+ (/ (* 15 SIZE) 16) (/ (* 2 SIZE) 3)) 2) (/ (+ (/ SIZE 3) (/ (* 2 SIZE) 3)) 2))
                        (make-posn (/ (+ (/ SIZE 3) (/ SIZE 16)) 2) (/ (+ (/ (* 2 SIZE) 3) (/ (* 15 SIZE) 16)) 2))
                        (make-posn (/ (+ (/ SIZE 3) (/ (* 2 SIZE) 3)) 2) (/ (+ (/ (* 2 SIZE) 3) (/ (* 15 SIZE) 16)) 2))
                        (make-posn (/ (+ (/ (* 15 SIZE) 16) (/ (* 2 SIZE) 3)) 2) (/ (+ (/ (* 2 SIZE) 3) (/ (* 15 SIZE) 16)) 2))
                        ))
(define blank (square 0 "solid" "white"))
(define xWins (text "X Wins" (round (/ SIZE 4)) "Green"))
(define oWins (text "O Wins" (round (/ SIZE 4)) "Green"))
(define draw (text "Draw" (round (/ SIZE 4)) "Green"))

;;Data Definitions:

;Board
;Board is a list of either strings, X or O, or false
;(listof String|false)
;interp. String is either "X"|"O" ("X" = human, "O" = Computer)
;        false is an empty space

(define b0 (list false false false ;empty board
                 false false false
                 false false false))

(define b1 (list false false false  ;;middle of game
                 false  "X"  false
                 false false  "O" ))

(define b5 (list false false false  ;;middle of game
                 "X"   "X"  false
                 false false  "O" ))


(define b2 (list false  "X"  false ; human wins
                 false  "X"   "O"
                 false  "X"   "O" ))

(define b3 (list false false  "O" ;computer wins
                 "X"    "X"   "O"
                 false  "X"   "O"))

(define b4 (list "O" "X" "X" ;Computer wins
                 "X" "O" "O"
                 "X" "X" "O"))

(define b6 (list "O" "O" "X" ;draw
                 "X" "X" "O"
                 "O" "X" "X"))

(define (fn-for-board brd)
  (cond [(empty? brd) ...]
        [else (...
               (first brd)
               (rest brd))]))

;;World-state 
(define-struct ws (board turn trm winner))
;world state is (make-ws board boolean boolean)
;interp. board is the current tic tac toe board
;        turn is who's turn it is
;             -computer - true
;             -human -    false
;        trm is if the game is over
;             -true - game over
;             -false - game ongoing
;        winner is an image of text stating who won
;             -square of size 0 if no one has won
;             -image that says either "X Wins", "y Wins",or "Draw"

(define ws0 (make-ws b0 false false blank))
(define ws1 (make-ws b1 false false blank))
(define ws2 (make-ws b2 true true xWins))
(define ws3 (make-ws b3 false true oWins))
(define ws4 (make-ws b4 true true oWins))
(define ws5 (make-ws b5 true false blank))
(define ws6 (make-ws b6 true true draw))

(define (fn-for-ws ws)
  (... (fn-for-board (ws-board ws))
       (ws-turn ws)
       (ws-trm ws)))

(define START ws0)

;Functions:

;; (list of Naturals) -> (list of Naturals)
;;Purpose: takes in a board and reutrns a list of the valid move positions
;(define (valid-moves lon) empty)

(check-expect (valid-moves b0) (list 0 1 2 3 4 5 6 7 8))
(check-expect (valid-moves b6) empty)

(define (valid-moves lon)
  (local[(define (valid-moves lon cnt result)
            (cond [(empty? lon) result]
                  [(false? (first lon))
                   (valid-moves (rest lon) (add1 cnt) (cons cnt result))]
                  [else
                   (valid-moves (rest lon) (add1 cnt) result)]))]
    (reverse(valid-moves lon 0 empty))))

;Board String Natural[0, 8] -> Board
;purpose: put a "X" or "O" (the consumed string) in board at position indicated
;(define (move b c num) b0) ;stub
(check-expect (move b0 "X" 4) (list false false false
                                    false  "X"  false
                                    false false false))
(check-expect (move b1 "X" 0) (list  "X"  false false
                                     false  "X"  false
                                     false false  "O" ))
(check-expect (move b5 "O" 0) (list  "O"  false false
                                     "X"   "X"  false
                                     false false  "O" ))
(check-expect (move b4 "O" 4) b4)

;Template taken from board template

(define (move b c num)
  (append (take b num) (list c) (drop b (add1 num))))

;; Board Natural -> ws
;; purpose: place an X in a position if it is open
;;(define (move-human b p) ws) ;stub


(check-expect (move-human b0 0) (make-ws (list  "X"  false false
                                               false false false
                                               false false false) true false blank))
(check-expect (move-human b1 4) (make-ws b1 false false blank))

;template taken from board
(define (move-human b p)
(local [(define loi (valid-moves  b))]
  (if (member p loi)
      (make-ws (move b "X" p) true false blank)
      (make-ws b false false blank))))

;; Board -> Integer
;; purpose: chooses a random position for the computer's next move; -1 will be sent back when the board is full (error)
;;(define (selectPCMove b) 0) ;stub


(check-satisfied (selectPCMove b5) (lambda (x) (member x (valid-moves b5))))
(check-satisfied (selectPCMove b0) (lambda (x) (member x (valid-moves b0))))
(check-satisfied (selectPCMove b1) (lambda (x) (member x (valid-moves b1))))
(check-expect (selectPCMove b4) -1)

;template taken from board
(define (selectPCMove b)
  (local [(define loi (valid-moves b))]
    (if (empty? loi)
        -1
        (list-ref loi (random (length loi))))))

;board -> boolean
;purpose: returns true if the board is full else false
;(define (full? b) false)

(check-expect (full? b0) false)
(check-expect (full? b1) false)
(check-expect (full? b4) true)

;template taken from board
(define (full? b)
  (cond [(empty? b) true]
        [(false? (first b)) false]
        [else
         (full? (rest b))]))

;terminate
;Board -> Boolean
;Purpose: determine whether the game is still ongoing (i.e. no one has won and there are still positions available on the board)
;(define (terminate? b) false)

(check-expect (winner? b0) false)
(check-expect (winner? b1) false)
(check-expect (winner? b2) true)
(check-expect (winner? b3) true)
(check-expect (winner? b4) true)
(check-expect (winner? b5) false)
(check-expect (winner? b6) false)

;;template taken from board
(define (winner? b)
  (local [(define (win? lou)
            (ormap threeinrow? lou))

          (define (threeinrow? u)
            (local [(define prior (list-ref b (first u)))
                    (define (threeinrow? u)
                      (cond [(empty? u) true]
                            [(false? (list-ref b (first u))) false]
                            [(string=? (list-ref b (first u)) prior)
                             (threeinrow? (rest u))]
                            [else false]))]
              (threeinrow? u)))]
    (win? units)))

;ws -> ws
;;purpose: change the worldstate depending on turn and if the game is over
;(define (tock ws) ws)

(check-expect (tock ws0) ws0)
(check-expect (tock (make-ws b2 true false blank)) ws2)

;template taken from ws
(define (tock ws)
  (cond 
    [(winner? (ws-board ws))
     (make-ws (ws-board ws) (ws-turn ws) true (if (ws-turn ws) xWins oWins))]
    [(full? (ws-board ws)) (make-ws (ws-board ws) (ws-turn ws) true draw)]
    [(ws-turn ws)
     (make-ws (move (ws-board ws) "O" (selectPCMove (ws-board ws))) false false blank)]
    [else ws]
    ))

;;board -> (listof X)
;;Purpose: produces a list of X's and O's on the board
;;(define (getOX board) empty)

(check-expect (get b0 (λ (x i) (if (string=? x "X") X O))) empty)
(check-expect (get b1 (λ (x i) (if (string=? x "X") X O))) (list X O))
(check-expect (get b4 (λ (x i) (if (string=? x "X") X O))) (list O X X X O O X X O))
(check-expect (get b0 (λ (x i) i)) empty)
(check-expect (get b1 (λ (x i) i)) (list 4 8))
(check-expect (get b4 (λ (x i) i)) (list 0 1 2 3 4 5 6 7 8))
              

;template taken from board
(define (get brd fn)
  (local[(define (get brd res index)
           (cond [(empty? brd) res]
                 [(false? (first brd))
                  (get (rest brd) res (add1 index))]
                 [else (get (rest brd) (cons (fn (first brd) index) res) (add1 index))]))]
    (reverse (get brd empty 0))))

;render
;WS -> Image
;Purpose: display a board that reflects the current state of the world
;(define (render ws) MTS)

(check-expect (render ws0) BOARD)
(check-expect (render ws1)  (place-images
                             (list X
                                   O)
                             (list (list-ref POSITIONS 4)
                                   (list-ref POSITIONS 8))
                             BOARD))
(check-expect (render ws4) (overlay oWins (place-images
                                           (list O X X
                                                 X O O
                                                 X X O)
                                           POSITIONS
                                           BOARD)))

(define (render ws)
  (overlay (ws-winner ws) (place-images (get (ws-board ws) (λ (x i) (if (string=? x "X") X O)))
                                        (map (λ (x) (list-ref POSITIONS x)) (get (ws-board ws) (λ (x i) i)))
                                        BOARD)))

;ws Natural (list of Naturals) -> ws
;Purpose: Returns a ws with an X placed in the correct position
;(define (searchCol ws y col) ws)

(check-expect (searchCol ws0 0 (list 0 3 6)) ws0)
(check-expect (searchCol ws1 (/ SIZE 2) (list 1 4 7)) ws1)
(check-expect (searchCol ws0 (/ SIZE 2) (list 1 4 7)) (make-ws (list false false false
                                                                     false  "X"  false
                                                                     false false false) true false blank))

;template taken from ws
(define (searchCol ws y col)
  (cond [(and (< y (/ SIZE 3)) (> y (/ SIZE 16))) (move-human (ws-board ws) (list-ref col 0))]
            [(and (< y (/ (* 2 SIZE) 3)) (> y (/ SIZE 3))) (move-human (ws-board ws) (list-ref col 1))]
            [(and (< y (/ (* 15 SIZE) 16)) (> y (/ (* 2 SIZE) 3))) (move-human (ws-board ws) (list-ref col 2))]
            [else ws]))

;;ws Natural Natural mouseEvent -> ws
;;Purpose: When it is the player's turn place an X at an empty clicked position
;(define (handle-click ws x y me) ws)

(check-expect (handle-click ws0 0 0 "button-down") ws0)
(check-expect (handle-click ws1 (/ SIZE 2) (/ SIZE 2) "button-down") ws1)
(check-expect (handle-click ws0 (/ SIZE 2) (/ SIZE 2) "button-down") (make-ws (list false false false
                                                                                    false  "X"  false
                                                                                    false false false) true false blank))
(check-expect (handle-click ws6 (/ SIZE 2) (/ SIZE 2) "button-down") ws6)
(check-expect (handle-click ws0 (/ SIZE 2) (/ SIZE 2) "button-up") ws0)

;template taken from ws
(define (handle-click ws x y me)
  (if (and (string=? me "button-down") (not (ws-trm ws)))
      (cond [(and (< x (/ SIZE 3)) (> x (/ SIZE 16))) (searchCol ws y (list-ref cols 0))]
            [(and (< x (/ (* 2 SIZE) 3)) (> x (/ SIZE 3))) (searchCol ws y (list-ref cols 1))]
            [(and (< x (/ (* 15 SIZE) 16)) (> x (/ (* 2 SIZE) 3))) (searchCol ws y (list-ref cols 2))]
            [else ws])
      ws))

;; will need this for extra credit
(define (handle-key ws ke) ws)


(define (main ws)
  (big-bang ws ; WS
    (on-tick tock) ; WS -&gt; WS
    (to-draw render) ; WS -&gt; Image
    (on-mouse handle-click) ; WS Integer Integer MouseEvent -&gt; WS
    (on-key handle-key))) ; WS KeyEvent -&gt; WS