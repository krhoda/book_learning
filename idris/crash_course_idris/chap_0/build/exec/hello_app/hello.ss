#!/usr/bin/scheme --script

(import (chezscheme))
(case (machine-type)
  [(i3le ti3le a6le ta6le) (load-shared-object "libc.so.6")]
  [(i3osx ti3osx a6osx ta6osx) (load-shared-object "libc.dylib")]
  [(i3nt ti3nt a6nt ta6nt) (load-shared-object "msvcrt.dll")                           (load-shared-object "ws2_32.dll")]
  [else (load-shared-object "libc.so")])



(let ()
(define (blodwen-os)
  (case (machine-type)
    [(i3le ti3le a6le ta6le) "unix"]
    [(i3osx ti3osx a6osx ta6osx) "darwin"]
    [(i3nt ti3nt a6nt ta6nt) "windows"]
    [else "unknown"]))

(define blodwen-read-args (lambda (desc)
  (case (vector-ref desc 0)
    ((0) '())
    ((1) (cons (vector-ref desc 2)
               (blodwen-read-args (vector-ref desc 3)))))))
(define b+ (lambda (x y bits) (remainder (+ x y) (expt 2 bits))))
(define b- (lambda (x y bits) (remainder (- x y) (expt 2 bits))))
(define b* (lambda (x y bits) (remainder (* x y) (expt 2 bits))))
(define b/ (lambda (x y bits) (remainder (exact-floor (/ x y)) (expt 2 bits))))

(define blodwen-shl (lambda (x y) (ash x y)))
(define blodwen-shr (lambda (x y) (ash x (- y))))
(define blodwen-and (lambda (x y) (logand x y)))
(define blodwen-or (lambda (x y) (logor x y)))
(define blodwen-xor (lambda (x y) (logxor x y)))

(define cast-num
  (lambda (x)
    (if (number? x) x 0)))
(define destroy-prefix
  (lambda (x)
    (cond
      ((equal? x "") "")
      ((equal? (string-ref x 0) #\#) "")
      (else x))))
(define cast-string-int
  (lambda (x)
    (floor (cast-num (string->number (destroy-prefix x))))))
(define cast-int-char
  (lambda (x)
    (if (and (>= x 0)
             (<= x #x10ffff))
        (integer->char x)
        0)))
(define exact-floor
  (lambda (x)
    (inexact->exact (floor x))))
(define cast-string-double
  (lambda (x)
    (cast-num (string->number (destroy-prefix x)))))
(define string-cons (lambda (x y) (string-append (string x) y)))
(define get-tag (lambda (x) (vector-ref x 0)))
(define string-reverse (lambda (x)
  (list->string (reverse (string->list x)))))
(define (string-substr off len s)
    (let* ((l (string-length s))
          (b (max 0 off))
          (x (max 0 len))
          (end (min l (+ b x))))
          (if (> b l)
              ""
              (substring s b end))))

(define either-left
  (lambda (x)
    (vector 0 x)))

(define either-right
  (lambda (x)
    (vector 1 x)))

(define blodwen-error-quit
  (lambda (msg)
    (display msg)
    (newline)
    (exit 1)))

(define (blodwen-get-line p)
    (if (port? p)
        (let ((str (get-line p)))
            (if (eof-object? str)
                ""
                str))
        void))

(define (blodwen-get-char p)
    (if (port? p)
        (let ((chr (get-char p)))
            (if (eof-object? chr)
                #\nul
                chr))
        void))

;; Buffers

(define (blodwen-new-buffer size)
  (make-bytevector size 0))

(define (blodwen-buffer-size buf)
  (bytevector-length buf))

(define (blodwen-buffer-setbyte buf loc val)
  (bytevector-u8-set! buf loc val))

(define (blodwen-buffer-getbyte buf loc)
  (bytevector-u8-ref buf loc))

(define (blodwen-buffer-setint buf loc val)
  (bytevector-s64-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getint buf loc)
  (bytevector-s64-ref buf loc (native-endianness)))

(define (blodwen-buffer-setint32 buf loc val)
  (bytevector-s32-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getint32 buf loc)
  (bytevector-s32-ref buf loc (native-endianness)))

(define (blodwen-buffer-setdouble buf loc val)
  (bytevector-ieee-double-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getdouble buf loc)
  (bytevector-ieee-double-ref buf loc (native-endianness)))

(define (blodwen-stringbytelen str)
  (bytevector-length (string->utf8 str)))

(define (blodwen-buffer-setstring buf loc val)
  (let* [(strvec (string->utf8 val))
         (len (bytevector-length strvec))]
    (bytevector-copy! strvec 0 buf loc len)))

(define (blodwen-buffer-getstring buf loc len)
  (let [(newvec (make-bytevector len))]
    (bytevector-copy! buf loc newvec 0 len)
    (utf8->string newvec)))

(define (blodwen-buffer-copydata buf start len dest loc)
  (bytevector-copy! buf start dest loc len))

; 'dir' is only needed in Racket
(define (blodwen-read-bytevec curdir fname)
  (guard
    (x (#t #f))
    (let* [(h (open-file-input-port fname
                                    (file-options)
                                    (buffer-mode line) #f))
           (vec (get-bytevector-all h))]
      (begin (close-port h)
             vec))))

(define (blodwen-isbytevec v)
(if (bytevector? v)
    0
    -1))

; 'dir' is only needed in Racket
(define (blodwen-write-bytevec curdir fname vec max)
  (guard
    (x (#t -1))
    (let* [(h (open-file-output-port fname (file-options no-fail)
                                     (buffer-mode line) #f))]
      (begin (put-bytevector h vec 0 max)
             (close-port h)
             0))))



;; Threads

(define blodwen-thread-data (make-thread-parameter #f))

(define (blodwen-thread p)
    (fork-thread (lambda () (p (vector 0)))))

(define (blodwen-get-thread-data ty)
  (blodwen-thread-data))

(define (blodwen-set-thread-data a)
  (blodwen-thread-data a))

(define (blodwen-mutex) (make-mutex))
(define (blodwen-lock m) (mutex-acquire m))
(define (blodwen-unlock m) (mutex-release m))
(define (blodwen-thisthread) (get-thread-id))

(define (blodwen-condition) (make-condition))
(define (blodwen-condition-wait c m) (condition-wait c m))
(define (blodwen-condition-wait-timeout c m t) (condition-wait c m t))
(define (blodwen-condition-signal c) (condition-signal c))
(define (blodwen-condition-broadcast c) (condition-broadcast c))

(define (blodwen-sleep s) (sleep (make-time 'time-duration 0 s)))
(define (blodwen-usleep s)
  (let ((sec (div s 1000000))
        (micro (mod s 1000000)))
       (sleep (make-time 'time-duration (* 1000 micro) sec))))

(define (blodwen-time) (time-second (current-time)))
(define (blodwen-clock-time-utc) (current-time 'time-utc))
(define (blodwen-clock-time-monotonic) (current-time 'time-monotonic))
(define (blodwen-clock-time-duration) (current-time 'time-duration))
(define (blodwen-clock-time-process) (current-time 'time-process))
(define (blodwen-clock-time-thread) (current-time 'time-thread))
(define (blodwen-clock-time-gccpu) (current-time 'time-collector-cpu))
(define (blodwen-clock-time-gcreal) (current-time 'time-collector-real))
(define (blodwen-is-time? clk) (if (time? clk) 1 0))
(define (blodwen-clock-second time) (time-second time))
(define (blodwen-clock-nanosecond time) (time-nanosecond time))

(define (blodwen-args)
  (define (blodwen-build-args args)
    (if (null? args)
        (vector 0) ; Prelude.List
        (vector 1 (car args) (blodwen-build-args (cdr args)))))
    (blodwen-build-args (command-line)))

(define (blodwen-hasenv var)
  (if (eq? (getenv var) #f) 0 1))

(define (blodwen-system cmd)
  (system cmd))

;; Randoms
(define random-seed-register 0)
(define (initialize-random-seed-once)
  (if (= (virtual-register random-seed-register) 0)
      (let ([seed (time-nanosecond (current-time))])
        (set-virtual-register! random-seed-register seed)
        (random-seed seed))))

(define (blodwen-random-seed seed)
  (set-virtual-register! random-seed-register seed)
  (random-seed seed))
(define blodwen-random
  (case-lambda
    ;; no argument, pick a real value from [0, 1.0)
    [() (begin
          (initialize-random-seed-once)
          (random 1.0))]
    ;; single argument k, pick an integral value from [0, k)
    [(k)
      (begin
        (initialize-random-seed-once)
        (if (> k 0)
              (random k)
              (assertion-violationf 'blodwen-random "invalid range argument ~a" k)))]))
(define PrimIO-prim__putStr (lambda (farg-0 farg-1) ((foreign-procedure #f "idris2_putStr" (string) void) farg-0) (vector 0 )))
(define prim__add_Integer (lambda (arg-0 arg-1) (+ arg-0 arg-1)))
(define prim__sub_Integer (lambda (arg-0 arg-1) (- arg-0 arg-1)))
(define prim__mul_Integer (lambda (arg-0 arg-1) (* arg-0 arg-1)))
(define prim__lte_Integer (lambda (arg-0 arg-1) (or (and (<= arg-0 arg-1) 1) 0)))
(define prim__strAppend (lambda (arg-0 arg-1) (string-append arg-0 arg-1)))
(define Main-main (lambda (ext-0) (PrimIO-putStrLn "Hello, World!" ext-0)))
(define Prelude-case--3638-3924 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (cond ((equal? sc0 0) 0) (else (+ 1 (- arg-0 1)))))))
(define Prelude-fromInteger_Num__Integer (lambda (ext-0) ext-0))
(define Prelude-C-43_Num__Integer (lambda (ext-0 ext-1) (+ ext-0 ext-1)))
(define Prelude-natToInteger (lambda (arg-0) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 0)(else (let ((e-0 (- arg-0 1))) (Prelude-C-43_Num__Integer (Prelude-fromInteger_Num__Integer 1) e-0)))))))
(define Prelude-integerToNat (lambda (arg-0) (Prelude-case--3638-3924 arg-0 (let ((sc0 (or (and (<= arg-0 0) 1) 0))) (cond ((equal? sc0 0) 1)(else 0))))))
(define Prelude-intToBool (lambda (arg-0) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 1)(else 0)))))
(define Prelude-id (lambda (arg-0 arg-1) arg-1))
(define PrimIO-case--342-427 (lambda (arg-0 arg-1 arg-2 arg-3) (PrimIO-unsafeDestroyWorld 'erased 'erased arg-3)))
(define PrimIO-unsafePerformIO (lambda (arg-0 arg-1) (PrimIO-unsafeCreateWorld 'erased (lambda (w) (PrimIO-case--342-427 'erased arg-1 'erased (arg-1 w))))))
(define PrimIO-unsafeDestroyWorld (lambda (arg-0 arg-1 arg-2) arg-2))
(define PrimIO-unsafeCreateWorld (lambda (arg-0 arg-1) (arg-1 #f)))
(define PrimIO-putStrLn (lambda (arg-0 ext-0) (PrimIO-putStr (string-append arg-0 "\xa;") ext-0)))
(define PrimIO-putStr (lambda (arg-0 ext-0) (PrimIO-prim__putStr arg-0 ext-0)))
(define PrimIO-primIO (lambda (arg-0 arg-1) arg-1))
(define Builtin-assert_total (lambda (arg-0 arg-1) arg-1))
(load-shared-object "libidris2_support.so")
(PrimIO-unsafePerformIO 'erased (lambda (eta-0) (Main-main eta-0))))