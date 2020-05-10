#lang scribble/manual

@title{jsonic: because JSON is boring}
@author{Kelsey Rhoda}

@defmodulelang[jsonic]

@section{Introduction}

This is a domain-specific language it relies on @racketmodname[json] library.
Mostly the @racket[jsexpr->string] function.

If we start with this:

@verbatim|{
#lang jsonic
[
  @$ 'null $@,
  @$ (* 6 7) $@,
  @$ (= 2 (+ 1 1)) $@
]
}|

We'll end up with this:

@verbatim{
[
  null,
  42,
  true
]
}