-module(demo_record).
-export([wrd_count_char/1, map_search_pred/2, test_map_search/0]).

-record(todo, {
    status = reminder,
    who = puppy,
    text
}).

wrd_count_char(Str) -> wrd_count_char(Str, #{}).

wrd_count_char([], X) -> X;
wrd_count_char([H | T], X) -> 
    case X of
        #{H := N} -> wrd_count_char(T, X#{ H := N+1 });
        _ -> wrd_count_char(T, X#{ H => 1 })
    end.

% #todo{}.
% X1 = #todo{status = important, text = "wag tail"}
% X2 = X1#todo{status = done}
% #todo{status=WagStatus} = X2 
% WagStatus =:= done

% Maps:
% PuppyMap = #{ear => 2, tail => 1, paws => 4, bark => "loud"}.
% SmallPuppyMap = PuppyMap#{ bark := "soft"} 
%% => Create or Update.
%% := Update or Err.

map_search_pred(M, Pred) ->
    I = maps:iterator(M),
    map_iter_pred(I, Pred).

map_iter_pred(I, Pred) -> 
    case maps:next(I) of 
        none -> none;
        {K, V, I2} -> 
        case Pred(K, V) of
            true -> {K, V};
            _ -> map_iter_pred(I2, Pred)
        end
    end.

test_map_search() ->
    M = maps:new(),
    M1 = M#{ 1 => 1 },
    F = fun(X,Y) -> X =:= Y end,
    none = map_search_pred(M, F),
    {1, 1} = map_search_pred(M1, F),
    test_complete.