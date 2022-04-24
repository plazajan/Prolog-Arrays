
% A demo for
% Multi-dimensional, dynamic, logical arrays with logarithmic indexing, 
% implemented using standard featues of Prolog (ISO Prolog).

% Version of 2022/04/24

% https://github.com/plazajan
                    
% Copyright 1988-2022, Jan A. Plaza

% Use under Creative Commons Attribution Share-Alike International License 4.0

% -----------------------------------------------------------------------------

:- include('arrays.pl').

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
