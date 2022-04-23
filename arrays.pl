/* 
                       ARRAYS IMPLEMENTED IN PROLOG
                        
                     Copyright 1988-2022, Jan A. Plaza
Use under Creative Commons Attribution Share-Alike International License 4.0
              

We define multi-dimensional, dynamic, logical arrays with logarithmic 
indexing. The implementation uses only standard featues of Prolog (ISO Prolog).

By an array we mean an indexed container, not for a block of memory.
The arrays are tree-like terms which are manipulated by Prolog procedures.

Places in a K-dimensional array are indexed by K-tuples of indices,
i.e. lists of natural numbers. Indexing is zero-based.
One does not declare the size of an array; arbitrarily large indices
are allowed - this is why these arrays are called dynamic. 
The array grows as needed, however without reallocating memory. 
The arrays, like Prolog's variables, are local to procedures and admit only 
the usual logical assignment - incremental assignment (by unification) 
that can be undone by backtracking; this is why they are called logical. 
   
An empty place in an array is represented by a variable. If such a
variable is unified with a term, the term is stored in the array. 
If a term T1 is put in a place where T2 is stored, T1 and T2 are
pseudo-unified (T1=T2) and the result is stored in the array. 
If T1 and T2 do not pseudo-unify the procedure fails. 
Backtracking can undo the pseudo-unification. 

Once an element is put into an array it can be read but it can not be
removed (except by backtracking). Instead of removing an
element e1 and putting a new one e2 in its place, one can store terms like
[e1|X] and then modify X, e.g. X=[e2|X1], etc. Another
possibility is to replace the entire array by a new one like
the original one except that the element in question is replaced by another;
a suitable procedure is provided. 
   
One cannot distinguish between an empty place in an array and a
place in which a variable is stored; therefore to store a variable, say V,
it is better to store a term that contains the variable, say [V]. 

In the implementation, the effect of multiple dimensions is obtained by
storing one-dimensional arrays in one-dimensional arrays in
one-dimensional arrays, etc. E.g. the goal 
 
    getFromArray(Array3,[7,11],X) 

is equivalent to 

    getFromArray(Array3,[7],AuxArray), getFromArray(AuxArray,[11],X)
    
One does not declare the number of dimensions of an array but it is
determined by the length of the index list. 
   
The access time to the N-th place of a one-dimensional array is of the order
logN (for all the procedures below except changeArray and genArrayMembers). 
The arrays are dynamic data structures; the amount of space they occupy 
in the memory increases with the number of elements stored.
An one-dimensional array that stores only one item, at index N, 
uses auxiliary space of the order logN. 
A one-dimnsional array that stores items at indices 0..N only
uses auxilairy space of the order N, not counting the space used by the itmes. 
(This asymptotic estimate is the same as for the auxilary space
taken by a list with N elements.)

The following predicates are defined.

1. putIntoArray(Array, Position, Element)
   Arguments: 
      Array - a term representing array (initially a variable)
      Position - a non-empty list of natural numbers (>=0)
      Element - a term (typically an atom but variables and open terms are 
                allowed)
   Result:
      Element is pseudo-unified with the term stored at the Position or
      with the variable representing this place if the place is empty. If
      the terms do not unify the procedure fails.
      Array becomes a term representing the initial array with the result of   
      pseudo-unification stored at the position Position.
   Backtracking:
      The second call fails.

2. putIntoArrayM(Array, Position, Element)
   exactly like putIntoArray(Array, Position, Element) except that the
   following messages are supplied for the purpose of debugging: 
   "ERROR! Incorrect specification of the position Position.   
    putIntoArrayM failed." 
   "The element put in the position Position is not    
    pseudo-unifiable with the element stored. 
    putIntoArrayM failed."

3. getFromArray(Array, Position, Element)
   Arguments: 
      Array - a term representing array 
      Position - a non-empty list of natural numbers (>=0)
      Element - a term (typically a variable)
   Result:
      Element is pseudo-unified with the term stored at the Position. If 
      terms do not unify the procedure fails. If this place is empty or there 
      is only a variable the procedure fails.
   Backtracking:
      The second call fails.

4. changeArray(Array, Position, NewElement, NewArray)
   Arguments: 
      Array - a term representing array
      Position - a non-empty list of natural numbers (>=0)
      NewElement - a term (typically an atom but variables and open terms are
                allowed)
   NewArray - a variable
   Result:
      NewArray becomes a term representing the array containing the            
      elements Array that contains except Position where NewElement is 
      stored. Array and NewArray have a large part of their structure in 
      common; therefore it is advised not to use Array after NewArray is 
      obtained - some changes made to Array may cause changes to
      NewArray, some others need not.
   Backtracking:
      The second call fails.

5. lastInArray(Array, Position, Element)
   Arguments: 
      Array - a term representing array 
      Position - a non-empty list of variables
      Element - a term (typically a variable)
   Result:
      Variables of the list Position are instantiated to the indices of the 
      place in Array which contains a non-variable and is last in the 
      lexicographical order. If there are no non-variables in the array the 
      procedure fails.
      Element is pseudo-unified with the term stored at this place. If the      
      terms do not unify the procedure fails.
   Backtracking:
      The second call fails.

6. genArrayMembers(Array, Position, Element)
   Arguments: 
      Array - a term representing array 
      Position - a non-empty list of variables
      Element - a variable
   Result:
      Variables of the list Position are instantiated to the indices of the 
      place in Array which contains a non-variable and is first in the 
      lexicographical order. If there are no non-variables in the array 
      the procedure fails.
   Element is instantiated to the term stored at this place.
   Backtracking:
   Every next call returns the lexicographically next non-variable element 
      and its position.


The following terms are used to represent arrays:
   
* ------- * ------- * ------- * ------- ...
|         |         |         |
0         #         #         #
         / \       / \       / \
         1-5      #...#      ...  
                 / \   \
                6- 10...30

where each * is a cons cell and each # consists of four cons cells
representing [X1, X2, X3, X4 | X5]. Do not think about this as a list 
with the rest X5; it is just a way to store five items. 
When this implementation was deveoped, using four cons cells 
was slightly more efficient than using user-defined function symbol of
arity 5. (Comments welcome.)

The trees built of #'s are of rank (branching factor) 5. One can modify the
construction changing the rank to any k >= 2. In such an implementation,
the time to put an element in the Nth place of an array can be bounded
by (c1*k+c2)log N where the base of the logarithm is k, and where c1, c2
are constants that depend on the platform. 
According to tests, in the 1988 LPA Prolog 2.0w on a Mac Plus, rank 5 is 
the most efficient while using indices from 0 to around 100. If one is going
to use indices that are many orders bigger it may be better to change the
rank to a bigger value. If lists are implemented in a standard way 
the choice of the rank does not affect the asymptotic estimate of the 
auxiliary space used by the array. (Comments welcome.)

A major characteristic of Prolog is that of a logical variable, i.e. a
local variable with a nondestructive, incremental assignment that can be
undone by backtracking. The implementation below shares these features.
 
Modern implementations of Prolog provide some versions of arrays. 
There are global arrays in GNU Prolog, and in SWI Prolog arrays 
can be simulated by setarg or nb_setarg; while these arrays are 
of arbitrary fixed size, our arrays grow dynamically.

The code has been tested in SWI Prolog 8.4.2 and GNU Prolog 1.5.0, in 2022.
*/

% putIntoArray(+Array, +PositionList, +Element).
% A new Array is an uninstantiated variable.
% The call modifies Array (partly instantiates it).
% This partly instantiated term can be used in subsequent calls.
% PositionList is a list of indexes (natural numbers).
% Element is typically a ground term but can be a partly instantiated term. 
putIntoArray(A, [N], E) :-
    N > 0, !,
    N1 is (N-1)//5,
    R is (N-1) mod 5,
    A = [_|A1], 
    (R==0, X=[E,_,_,_|_] ;
     R==1, X=[_,E,_,_|_] ;
     R==2, X=[_,_,E,_|_] ;
     R==3, X=[_,_,_,E|_] ;
     R==4, X=[_,_,_,_|E]  
    ), !,
    putIntoArray(A1, [N1], X), !.
putIntoArray(A, [0], E) :- !,
    A = [E|_], !.
putIntoArray(A, [N|Rest], E) :-
    putIntoArray(SubA, Rest, E), 
    putIntoArray(A, [N], SubA), !.

% putIntoArrayM(+Array, +PositionList, +Element)
% Like putIntoArray.
% Provided for debugging. Prints error messages.
putIntoArrayM(Array, Position, Element) :-
    (true ; write('\a'),
        nl, write('ERROR! '),
        write('Incorrect specification of position: '),
        write(Position), nl,
        write('putIntoArrayM failed.'), nl,
        !, fail ),
putIntoArray(Array, Position, X), !,
    (true ; write('\a'),
        nl, write('The element you want to put in position '),
        write(Position),
        write('\nis not pseudo-unifiable with the element already stored.'),
        nl,
        write('putIntoArrayM failed.'), nl,
        !, fail), 
    X=Element, !. 

% getFromArray(+Array, +PositionList, -Element).
% Array must be partly instantiated.
% PositionList is a list of indexes (natural numbers).
% Element is typically an uninstantiated variable.
getFromArray(A, [N], E) :-
    N > 0, !,
    A = [_|A1], 
    nonvar(A1),
    N1 is (N-1)//5,
    R is (N-1) mod 5, !,
    getFromArray(A1, [N1], [B,C,D,F|G]),
    (R==0, nonvar(B), E=B ;
     R==1, nonvar(C), E=C ;
     R==2, nonvar(D), E=D ;
     R==3, nonvar(F), E=F ;
     R==4, nonvar(G), E=G  ), !.
getFromArray(A, [0], E) :- !,
    A = [E|_],
    nonvar(E), !.
getFromArray(A, [N|Rest], E) :-
    getFromArray(A, [N], SubA),
    getFromArray(SubA, Rest, E), !.

% changeArray(Array, +PositionList, +Element, -NewArray)
% Array must be partly instantiated. 
% New Array must be an uninstantiated variable.
% Array and NewArray will share some structure - do not use Array any more.
% PositionList is a list of indexes (natural numbers).
% Element is typically a ground term but can be a partly instantiated term.
changeArray(A, [N], E, NewA) :-
    N > 0, !,
    N1 is (N-1)//5,
    R is (N-1) mod 5, 
    A = [E1|A1], 
    putIntoArray(A1, [N1], [B,C,D,F|G]),
    (R==0, E1=[E,C,D,F|G] ;
     R==1, E1=[B,E,D,F|G];
     R==2, E1=[B,C,E,F|G];
     R==3, E1=[B,C,D,E|G];
     R==4, E1=[B,C,D,F|E] ), !,
    changeArray(A1, [N1], E1, NewA1),
    NewA=[E1|NewA1], !.
changeArray(A, [0], E, NewA) :- !,
    A = [_|A1],
    NewA=[E|A1], !.
changeArray(A, [N|Rest], E, NewA) :-
    putIntoArray(A, [N], SubA),
    changeArray(SubA, Rest, E, NewSubA),
    changeArray(A, [N], NewSubA, NewA), !.

% lastInArray(+Array, -PositionList, -Element).
% Array must be partly instantiated. 
% PositionList should be a list of variables,
% Element should be a variable ; 
% they are typically uninstantiated.
lastInArray(A, [N], E) :-
    A=[_|A1],
    nonvar(A1), !,
    lastInArray(A1, [N1], [B,C,D,F|G]),
    N5 is 5*N1,
    (nonvar(G), !, E=G, N is N5 + 5 ;
     nonvar(F), !, E=F, N is N5 + 4 ;
     nonvar(D), !, E=D, N is N5 + 3 ;
     nonvar(C), !, E=C, N is N5 + 2 ;
     nonvar(B), !, E=B, N is N5 + 1 ), !.
lastInArray(A, [N], E) :-
    A=[X|A1],
    var(A1), !,
    nonvar(X),
    N=0,
    E=X, !.
lastInArray(A, [N|Rest], E) :-
    lastInArray(A, [N], SubA),
    lastInArray(SubA, Rest, E), !.

% genArrayMembers(+Array, *PositionList, *Element).
% Array must be partly instantiated. 
% generates pairs PositionList, Element under backtracking.
% PositionList should be a list of variables,
% Element is typically a variable; 
% they are typically uninstantiated.
genArrayMembers(A, [N], E) :-
    A = [X|_],
    nonvar(X),
    N=0,
    E=X.
genArrayMembers(A, [N], E) :-
    A = [_|A1], 
    nonvar(A1),
    genArrayMembers(A1, [N1], [B,C,D,F|G]),
    N5 is 5*N1,
    (nonvar(B), E=B, N is N5 + 1 ;
     nonvar(C), E=C, N is N5 + 2 ;
     nonvar(D), E=D, N is N5 + 3 ;
     nonvar(F), E=F, N is N5 + 4 ;
     nonvar(G), E=G, N is N5 + 5  ).
genArrayMembers(A, [N|Rest], E) :-
    \+ Rest == [],
    genArrayMembers(A, [N], SubA),
    genArrayMembers(SubA, Rest, E).

% -----------------------------------------------------------------------------

demo1 :-
    write('1-dimensional array.'), nl,
    write('Attempting putIntoArray(MyArray, 3, 3).'), nl,
    putIntoArray(MyArray, 3, 3),
    write(MyArray). % this line not executed.
demo1 :-
    write('Failed.'), nl, nl,
    write('For diagnosis, use the M version: putIntoArrayM(MyArray, 3, 3).'),
    putIntoArrayM(MyArray, 3, 3),
    write(MyArray). % this line not executed.
demo1 :-
    nl, write('Try again.'), nl,
    write('putIntoArray(MyArray, [3], 3),'), nl,
    putIntoArray(MyArray, [3], 3),
    write('getFromArray(MyArray, [3], V).'), nl,
    getFromArray(MyArray, [3], V),
    write('V = '), write(V), write('.'), nl,
    write('Attempting putIntoArray(MyArray, [3], 33).'), nl,
    putIntoArray(MyArray, 3, 33).
demo1 :- 
    write('Failed.'), nl, nl,
    write('Try again: putIntoArray(MyArray, [3], 3),'), nl,
    putIntoArrayM(MyArray, [3], 3),
    write('For diagnosis, use the M version: putIntoArrayM(MyArray, [3], 33).'),
    putIntoArrayM(MyArray, [3], 33).
demo1 :-
    nl, 
    write('Let\'s try anew.'), nl,
    write('putIntoArray(MyArray, [3], 3),'), nl,
    putIntoArray(MyArray, [3], 3),
    write('putIntoArray(MyArray, [40], 40),'), nl,
    putIntoArray(MyArray, [40], 40),
    write('changeArray(MyArray, [3], 33), NewArray).'), nl,
    changeArray(MyArray, [3], 33, NewArray),
    write('getFromArray(NewArray, [3], V).'), nl,
    getFromArray(NewArray, [3], V),
    write('V = '), write(V), write('.'), nl,
    write('getFromArray(NewArray, [40], W).'), nl,
    getFromArray(NewArray, [40], W),
    write('W = '), write(W), write('.').
   
demo2 :-
    write('1-dimensional array.'), nl,
    write('putIntoArray(A, [1000], 1000),'), nl,
    putIntoArray(A, [1000], 1000),
    write('putIntoArray(A, [100], 100),'), nl,
    putIntoArray(A, [100], 100),
    write('putIntoArray(A, [10], 10),'), nl,
    putIntoArray(A, [10], 10),
    write('putIntoArray(A, [1], 1),'), nl,
    putIntoArray(A, [1], 1),
    nl, write('lastInArray(A, [Index], Value),'), nl,
    lastInArray(A, [Index], Value),
    write('Index = '), write(Index), 
    write(', Value = '), write(Value), write('.'), nl,
    nl, write('For the following we will trigger backtracking.'), nl,
    write('genArrayMembers(A, [I], V).'), nl,
    genArrayMembers(A, [I], V),
    write('I = '), write(I), write(', V = '), write(V), write('.'), nl,
    fail.
   
% demo3(-A).
demo3(A) :-
    write('1-dimensional array under backtracking.'), nl,
    write('Type semicolons (;) for more.'), nl,
    nl, write('putIntoArray(A, [0], 0).'),
    putIntoArray(A, [0], 0).
demo3(A) :-
    nl, write('putIntoArray(A, [1], 1).'),
    putIntoArray(A, [1], 1).
demo3(A) :-
    nl, write('putIntoArray(A, [2], 2).'),
    putIntoArray(A, [2], 2).
demo3(A) :-
    nl, write('putIntoArray(A, [3], 3).'),
    putIntoArray(A, [3], 3).
demo3(A) :-
    nl, write('putIntoArray(A, [4], 4).'),
    putIntoArray(A, [4], 4).
demo3(A) :-
    nl, write('putIntoArray(A, [5], 5).'),
    putIntoArray(A, [5], 5).
demo3(A) :-
    nl, write('putIntoArray(A, [6], 6).'),
    putIntoArray(A, [6], 6).
demo3(A) :-
    nl, write('putIntoArray(A, [1000], 1000).'),
    putIntoArray(A, [1000], 1000).

demo4 :-
    write('A 2-dimensional array.'), nl,
    write('putIntoArray(A, [0,0], 0).'), nl,
    putIntoArray(A, [0,0], 0),
    write('putIntoArray(A, [0,1], 1).'), nl,
    putIntoArray(A, [0,1], 1),
    write('putIntoArray(A, [1,0], 10).'), nl,
    putIntoArray(A, [1,0], 10),
    write('putIntoArray(A, [1,1], 11).'), nl,
    putIntoArray(A, [1,1], 11),
    nl,
    write('getFromArray(A, [1,0], V).'), nl,
    getFromArray(A, [1,0], V),
    write('V = '), write(V), write('.'), nl,
    nl,
    write('lastInArray(A, [Index], Value),'), nl,
    lastInArray(A, [Index1,Index2], Value),
    write('Index1 = '), write(Index1), write(', Index2 = '), write(Index2), 
    write(', Value = '), write(Value), write('.'), nl,
    nl, write('For the following we will trigger backtracking.'), nl,
    write('genArrayMembers(A, [I,J], V).'), nl,
    genArrayMembers(A, [I,J], W),
    write('I = '), write(I), write(', J = '), write(J), 
    write(', V = '), write(W), write('.'), nl,
    fail.

% demo5(-A, -B, -C, -D).
demo5(A00, A01, A10, A11) :-
    write('See the structure of four different 2-dimensional arrays.'), nl,
    write('putIntoArray(A00, [0,0], 0).'), nl,
    putIntoArray(A00, [0,0], 0),
    write('putIntoArray(A01, [0,1], 1).'), nl,
    putIntoArray(A01, [0,1], 1),
    write('putIntoArray(A10, [1,0], 10).'), nl,
    putIntoArray(A10, [1,0], 10),
    write('putIntoArray(A11, [1,1], 11).'),
    putIntoArray(A11, [1,1], 11).
% ----------------------------------------------------------------------------
