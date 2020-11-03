-module(bin_exer).

-export([rev_bytes/1, rev_bits/1, term_to_packet/1, packet_to_term/1]).

rev_bit(0) ->
    1;
rev_bit(1) ->
    0.

rev_bits_rec(Result, <<>>) ->
    Result;
rev_bits_rec(Result, <<H:1, T/bitstring>>) ->
    H2 = rev_bit(H),
    rev_bits_rec(<<Result/bitstring, H2:1>>, T).

rev_bits(Bytes) when is_binary(Bytes) ->
    rev_bits_rec(<<>>, Bytes);
rev_bits(_) ->
    error(notBytes).

rev_bytes_rec(Result, <<>>) ->
    Result;
rev_bytes_rec(Result, <<H:8, T/binary>>) ->
    rev_bytes_rec(<<H:8, Result/binary>>, T).

rev_bytes(Bytes) when is_binary(Bytes) ->
    rev_bytes_rec(<<>>, Bytes);
rev_bytes(_) ->
    error(notBytes).

term_to_packet(Term) ->
    H = 777,
    B = term_to_binary(Term),
    <<H:4, B/binary>>.

packet_to_term(<<_:4, B/binary>>) ->
    binary_to_term(B).


