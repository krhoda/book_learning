#lang basic-demo-2
1 rem gosub basic 
10 gosub 50
20 gosub 70
30 print "third"

31 rem uncomment 32 for return err
32 rem return

40 goto 90
50 print "first"
60 return
70 print "second"
80 return

81 rem gosub as expr.
90 x = 2 : y = 4
100 if x < y then gosub 140
110 goto 140
120 print "less"
130 return

131 rem for:
140 for x = 0 to 3
150 gosub 180
160 next x
170 goto 200
180 print x
190 return

191 rem step:
200 for x = 0 to 3 step .5
210 print x
220 next x

231 rem return to multiple midline gosub.
240 x = 10 : gosub 270
250 x = 20 : gosub 270
260 goto 290
270 print x
280 return

281 rem one last test:
290 for h = 1 to 2
300 for t = 2 to 4 step 2
310 for d = 9 to 8 step -1
320 gosub 340
330 next d : next t : next h : print "done" : end
340 print h ; t ; d
350 return