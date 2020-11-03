-module(bin_exer).

-export([rev_bytes/1]).

rev_bit(0) ->
    1;
rev_bit(1) ->
    0.


rev_bytes_rec(Result, <<>>) ->
    Result;
rev_bytes_rec(Result, <<H:8, T:binary>>) ->
    rev_bytes_rec(<<H:8, Result/binary>>, T).

rev_bytes(Bytes) when is_binary(Bytes) ->
    rev_bytes_rec(<<>>, Bytes);
rev_bytes(_) ->
    error(notBytes).

