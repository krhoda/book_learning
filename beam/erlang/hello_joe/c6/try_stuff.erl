-module(try_stuff).

-export([demo_try/0, debug_try/0, my_sqrt/1]).

gen_ex(1) -> a;
gen_ex(2) -> throw(a);
gen_ex(3) -> exit(a);
gen_ex(4) -> {'EXIT', a};
gen_ex(5) -> error(a).

demo_try() ->
    [catcher(I) || I <- [1,2,3,4,5]].

debug_try() ->
    [{I, (catch gen_ex(I))} || I <- [1,2,3,4,5]].

catcher(N) ->
    try gen_ex(N) of
        Val -> {N, normal, Val}
    catch
        throw:X -> {N, caught, thrown, X};
        exit:X -> {N, caught, thrown, X};
        error:X -> {N, caught, thrown, X}
    end.

my_sqrt(X) when X < 0 ->
    error({squareRootNegArgument, X});
my_sqrt(X) ->
    math:sqrt(X).
