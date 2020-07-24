/* Simple, limited version of addition */

myadd(0,0,0).
myadd(0,1,1).
myadd(1,0,1).
myadd(1,1,1).
myadd(0,0,0).
myadd(0,0,0).
myadd(0,0,0).
myadd(0,0,0).

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