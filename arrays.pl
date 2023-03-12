
% Multi-dimensional, dynamic, logical arrays with logarithmic indexing, 
% implemented in ISO Prolog.

% Version of 2022/04/24

% https://github.com/plazajan
                    
% Copyright 1988-2023, Jan A. Plaza

% This file is part of Prolog-Arrays. Prolog-Arrays is free software: 
% you can redistribute it and/or modify it under the terms 
% of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or (at your option) any later version. 
% Prolog-Arrays is distributed in the hope that it will be useful, 
% but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
% or FITNESS FOR A PARTICULAR PURPOSE. 
% See the GNU General Public License for more details. 
% You should have received a copy of the GNU General Public License 
% along with Prolog-Arrays. If not, see https://www.gnu.org/licenses/.

%------------------------------------------------------------------------------

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
