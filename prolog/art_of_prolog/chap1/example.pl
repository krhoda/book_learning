/* Format of Prolog */
/* functor(atom, Variable). */
/* I think that's a term? */
/* If no vars, ground */
/* If vars nonground */

/* Universal Facts */
/* All vars like pomegranates */
likes(X,pomegranates).

/* Simple, limited version of addition */
/* Identity Laws */
myadd(0,X,X).
myadd(X,0,X).
/* the rest */
myadd(1,1,2).
myadd(1,2,3).
myadd(2,1,3).
myadd(1,3,4).
myadd(3,1,4).
myadd(2,2,4).

/* myadd(1, 1, X)? X is 2*/
/* myadd(X, Y, 2)? X is 0,1,2 & Y is 0,1,2 */
/* myadd(X, X, 2)? X is 1 */

/* Biblical Family Truth Table */
male(terach).
male(abraham).
male(nachor).
male(haran).
male(isaac).
male(lot).

female(sarah).
female(milcah).
female(yiscah).

father(terach,abraham).
father(terach,nachor).
father(terach,haran).
father(abraham, isaac).
father(haran,lot).
father(haran,milcah).
father(haran,yiscah).

mother(sarah, isaac).

/* Conjuctive Queries like: */
% father(tetran,X),father(X, Y)?
% { X=abraham,Y=issac } & { X=haran,Y=lot }

% Rules
son(X,Y) :- father(Y,X),male(X).
daughter(X,Y) :- father(Y,X),female(X).
grandfather(X,Y) :- father(X,Z),father(Z,Y).