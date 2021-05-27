# Assignment 3

## Part 1:  a warehouse of widgets

In "part1.rkt"

You are working as a summer intern at a Widget maker.  Your boss is old school, and insists on your using beginning student language with list abbreviations for Part 1 (“If it was good enough for me when I was an intern, then it’s good enough for you.”)To help you get started with your task, your boss has given you a starter file you should use (starter.rkt).  For this assignment you will create a system that manages a warehouse of widgets.  Each widget has a name, the number in stock, the price of the widget, and the time to manufacture a new widget.  Additional widgets can be constructed, if the materials are available.  Thus, each widget also contains the necessary ingredients necessary to manufacture a new one.  The ingredients take the form of a list of components needed to manufacture a new item, where each component is a widget as well, so it is a recursive data definition.  You may assume the widgets form an arbitrary-arity tree rather than a graph (if you don’t know what that means, don’t worry).  Basic properties about widgetsYour boss has given you several start-up tasks to get used to the widget inventory system.  After developing the templates, he wants you to implement the following functions, and to provide a signature and test cases for each.  Note:  your boss doesn’t care about niceties of Racket naming conventions and wants the functions to have these names.  Changing the names or operand order will make your boss very grumpy.  All functions you develop should have a signature, purpose, and test cases.
1.    find-widget-name-longer-than.  widget natural -> (listof widget)This function will examine the widget, as well as all of the subwidgets used to manufacture it, and return all whose name length is longer than the specified natural.
2.    find-widget-quantity-over:  widget natural -> (listof widget)This function will examine the widget, as well as all of the subwidgets used to manufacture it, and return those whose quantity in stock is greater than the specified natural
3.    find-widgets-cheaper-than: widget number -> (listof widget)This function will examine the widget, as well as all of the subwidgets used to manufacture it, and return those whose price is less than the provided number
4.    find-widget-hard-make:  widget natural1 number2 -> (listof widget)This function will examine the widget, as well as all of the subwidgets used to manufacture it, and return those whose quantity in stock is less than natural1 or whose cost is greater than number2.There are three other functions you were supposed to write, but those were crossed out by someone with a note scribbled “Let’s not waste the intern’s time.”  What to submit:  a racket file called “part 1.rkt”, that satisfies your boss’ requirements.  

## Part 2:  generalizing your code

In "part2.rkt"
  
After finishing part 1, you’re worried your boss will keep coming back with a trivial list of modifications and extensions to those functions for you to work on all summer.  You’d prefer to have enough free time to work with the much trendier Object-Oriented Trash Can Widget group, who are having problems (https://xkcd.com/1888/).  However, the Advanced Widget Engineering Section is made up of the elite, so you’ll really need to impress people.  Therefore, you decide to get ahead of things and write an abstract function to help you handle future function requests from your boss.  To further cement your rebel status, you decide to upgrade to the intermediate student language with lambda for this part.  

**First**, use local to convert your template functions from part 1 into a single trampoline function.

**Second**, your goal is to recreate the 4 functions in part 1 as simply as possible.  Ideally you can write a single abstract function, which consumes a widget, that you can use to solve the four problems in part 1.   Document your abstract function with a purpose and signature.  Then, use it to recreate the 4 functions from part 1.  You could use the fold function from the videos.  However, since you don’t have to support as wide a range of capabilities it may be simpler to think about how your 4 functions in Part 1 vary and create a simpler function.  

**Third**, you’ve heard rumors that your boss will want functionality such as being able to find the most expensive widgets, or the widgets with the fewest parts in stock.  Create a function:sort-widgets: widget fn  (listof widget)
It sorts the (sub)widgets according to the specified order function, fn.  For example, it could order widgets by increasing price.    You think this task isn’t so bad, but are shocked to see a post-it note attached to your boss’ scribbles:  “If you want to impress me, refine the quicksort algorithm developed in class #10 to use filter instead of the smaller-than and larger-than functions.  Also don’t assume the elements in the list are unique.”  The handwriting is identical to that on the note reducing your workload in Part 1 from 7 functions to 4.  “P.S.  Reuse the abstract function you developed above to determine all of the (sub)widgets you will pass in to quicksort.”Use the sort-widgets abstract function to generate a longest-name-widget function for your boss, that returns the (sub)widget with the longest name.  Write a signature and test cases for this function.  You should of course also test sort-widgets with a different ordering function

## Part 3:  displaying widget trees

In "part3.rkt"

You are happy that you have gotten ahead of what your boss may ask for but are horrified to find some of his notes for additional tasks.  Apparently he wants you to be able to display a widget in a hierarchical manner.  For example, to construct Jewelry requires Rings, Necklaces, and Bracelets; to construct a Necklace requires Chains and Pendants.   In addition, there are notes scribbled that he would like to be able to highlight items that are low in stock, and those that cost more than a prescribed price.  However, there could be other reasons he might want to highlight an entry.  Mercifully, the only type of highlight he is interested in is changing the color of the text for certain types of exciting events such as a particular widget being too expensive, or having an odd number of letters in its name, or having a subwidget that is in short supply, or...   On the 
plus side, there is the beginnings of some code (“starter display.rkt”) left behind by a former intern who fled the company.  You should use ISL-lambda for this part.   

First, use your template function to design a function:simple-render: widget -> imageIt produces a simple (image-based) textual representation of the hierarchy of widgets.  It should look something like the above example.  

Once you have simple-render working, go back and writerender: widget fn -> imageGenerates a tree like simple render, but colors the text according to the function passed in.  For example, a function could have items under $10 be displayed in green text, over $25 in red text, and the rest in black text.  Or it could color items by how many are in stock, etc.

Rewrite simple-render to make use of render.  Then write two test functions for render.  One test should color text yellow if there are fewer than 10 items in stock, and red if there are fewer than 5 items in stock.  The other is up to you.  
