# Assignment 1

Question 1.  Write a function tricolor that consumes a string and a font size.  It should return that string as an image in the specified font size.  In addition, the first 1/3 of the characters in the string should be red, the middle 1/3 should be green, and the last 1/3 should be blue.  You may assume the length of the string is a multiple of 3.  Hint:  there is a function called text that is helpful. 

Question 2.  Write a function quadratic that accepts three inputs a, b, and c corresponding to the coefficients in the expression ax2 + bx + c = 0.  It returns the values of x that solve that algebraic expression (i.e., use the quadratic formula to solve for x).  Since the quadratic formula has a “+/-“ term, it returns two possible solutions.  To be able to return both values, you should define a structure called roots.  One field within roots corresponds to the “+“ term and the other field corresponds to the “-“ term in the quadratic formula.  If you are confused, you can work through the provided example in the starter file to better understand what is going on.  

Question 3.  Define a new type within Racket called simple-img.  A simple-img has a shape, a size, and a color.  The shape can be either a triangle, a square, or a circle.  The size is its area in pixels.  Color refers to the color of the object.  Write the data definition and template for simple-img.

Question 4.  Write a function bigger? that accepts two simple-img and outputs whether the first simple-img has a larger area than the second.  

Question 5.  Write a function build-image that consumes a simple-img and produces the corresponding image.  You should assume triangles are equilateral triangles.  Hint:  you’ll need a bit of basic algebra to convert the area into the arguments to pass into the image creation functions. 

Question 6.  The next two functions will work with a list of images (note:  not a list of simple-img; we’ll look at that later in the assignment).  Give the data definition and template for a list of images.

Question 7.  Write a function total-width that accepts a list of images and returns the summed width of every image in the list.

Question 8.  Write a function taller-than that accepts a list of images and a cutoff, and returns every image taller than the specified cutoff.  

Question 9.  Consider a list of simple-img.  Write a data definition and template for this type.

Question 10.  Write a function find-shape that accepts a list of simple-img and a String, and returns a list of all of the images of the specified type.  Look at the provided check-expect and think about exactly what is being returned before starting this question. 
