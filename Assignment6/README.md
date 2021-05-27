# Assignment 6

Creates the following macros in Racket for the creation of a directed graph.

```
;; creates a graph and some nodes
(new graph g0)
(vertex n0 in g0)
(vertex n1 in g0)
(vertex n2 in g0)

;; creates a set of edges in the graph
(edges n0 -> n1 <-> n2 -> n0)

;; checks whether there is an edge leading from n0 to n1> 
(->? n0 n1)
#t

;; checks whether there is an edge leading from n0 to n2> 
(->? n0 n2)
#f

;; checks whether there is a path from n0 to n2> 
(-->? n0 n2)
#t
```
