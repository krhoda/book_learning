#lang basic
01 rem variable assignment:
10 let x = "foo"
20 y = 42
30 let z = x
39 print "enter something to continue"
40 input i
50 print z ; y + y + 10 ; x ; i
51 rem associativity and precedence:
60 print -1 + 2 - 3 * (4 + 5) / 6 ^ 7 + 8 mod 9
70 print 1 + 2 * 3 rem 7
80 print (1 + 2) * 3 rem 9
90 print 3 + - 4 rem -1
100 print - 2 ^ 4 rem -16
110 print (- 2) ^ 4 rem 16
115 rem using vars:
120  x = 24 : d = 4 : b = 2 : c = 3
130 print x / d / b rem 3
140 print x / (d / b) rem 12
150 print b ^ c ^ b rem 64
160 print b ^ (c ^ b) rem 512