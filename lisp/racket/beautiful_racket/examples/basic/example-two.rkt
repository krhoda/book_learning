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

161 rem conditionals:
170 x = 3
180 if x > 0 then print x else 200 + 10
190 x = x - 1
200 goto 180
210 print "done"

220 rem numerical comparisons:
230 print 2 < 4 rem 1
240 print 2 > 4 rem 0
250 print 2 = 4 rem 0
260 print 2 <> 4 rem 1
270 print 2 < 4 or 2 > 4 or 2 = 4 rem 1
280 print 2 < 4 and 2 > 4 and 2 = 4 rem 0
290 print not 2 > 4 or not 2 < 4 rem 1

300 rem more expressions and comparisons:
310 if 2 < 4 then print "true" else print "false"
320 if 2 > 4 then print "true" else print "false"
330 if 2 > 4 then goto 7 * 50
340 print "not"
350 print "true"
360 if 2 < 4 then 300 + (40 + 40) else 370
370 print "not"
380 print "true"