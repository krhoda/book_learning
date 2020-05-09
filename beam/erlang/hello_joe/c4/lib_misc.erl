-module(lib_misc).

-export([for/3, qsort/1, odd_even_acc/1, my_tuple_to_list/1]).

-import(lists, [reverse/1, sum/1]).

for(Max, Max, F) ->
    [F(Max)];
for(I, Max, F) ->
    [F(I) | for(I + 1, Max, F)].

my_tuple_to_list(T) ->
    for(1,
        tuple_size(T),
        fun (I) ->
                element(I, T)
        end).

qsort([]) ->
    [];
qsort([Pivot | T]) ->
    qsort([X || X <- T, X < Pivot]) 
    ++ [Pivot] ++ 
    qsort([X || X <- T, X >= Pivot]).

odd_even_acc(L) ->
    oe_acc(L, [], []).

oe_acc([H | T], Odds, Evens) ->
    case H rem 2 of
      1 ->
          oe_acc(T, [H | Odds], Evens);
      0 ->
          oe_acc(T, Odds, [H | Evens])
    end;
oe_acc([], Odds, Evens) ->
    {reverse(Odds), reverse(Evens)}.

