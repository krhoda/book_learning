-module(geometry1).
-export([test/0, area/1, pythag/1, even/1, odd/1, split_opt/1, split_hand/1]).

area({rectangle, Width, Height}) -> Width * Height;
area({square, Side}) -> Side * Side;
area({circle, Radius}) -> 3.14159 * Radius * Radius;
area({right_triangle, X, Y}) -> (X * Y) / 2.

test() ->
    12 = area({rectangle, 3, 4}),
    144 = area({square, 12}),
    5.0 = area({right_triangle, 5, 2}),
    12.56636 = area({circle, 2}),
    tests_worked.

pythag(N) ->
    [ {A,B,C} ||
        A <- lists:seq(1,N),
        B <- lists:seq(1,N),
        C <- lists:seq(1,N),
        A+B+C =< N,
        A*A+B*B =:= C*C 
    ].

even (N) when N rem 2 =:= 0 -> true;
even (_) -> false.

odd (N) when N rem 2 =:= 0 -> false;
odd (_) -> true.

% odd (N) -> not even(N).

filt(F, X) -> [E || E <- X, F(E)].

split_hand(L) -> 
    OddsF = fun(X) -> odd(X) end,
    EvensF = fun(X) -> even(X) end,
    {filt(OddsF, L), filt(EvensF, L)}.

split_opt(L) -> help_split_opt(L, {[], []}).

help_split_opt([], Result) ->  Result;
help_split_opt([H | T], {Odds, Evens}) -> 
    case even(H) of
        true -> help_split_opt(T, {Odds, [H | Evens]});
        _ -> help_split_opt(T, {[H | Odds], Evens})
    end.

