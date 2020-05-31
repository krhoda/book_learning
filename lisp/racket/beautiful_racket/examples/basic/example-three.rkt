#lang basic-demo-2
1 rem gosub basic 
10 gosub 50
20 gosub 70
30 print "third"
40 goto 90
50 print "first"
60 return
70 print "second"
80 return

81 rem gosub as expr.
90 x = 2 : y = 4
100 if x < y then gosub 40
110 goto 140
120 print "less"
130 return

131 rem for:
140 for x = 0 to 3
150 print x
160 next x