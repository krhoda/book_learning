-module(dust_bin).

%% Pack N Send
% X = {binaries, "are", useful}
% B = term_to_binary(X).
% T = binary_to_term(B)
% T =:= X

% Bin Data
% Binary = <<X:3, Y:7, Z:6>>
% ByteStrings = <<X:1, Y:2>> % NOT DIVISIBLE BY 8.

% Given <<E1, E2, .., En>> of pattern matching:
% En :: Value 
% | Value:Size 
% | Value/TypeSpecifierList 
% | Value:Size/TypeSpecifierList

% TypeSpecifierList
% End :: big | little | native
% {
%   <<16#12345678:32/big>>, % <<18,52,86,120>>,
%   <<16#12345678:32/little>>, % <<120,86,52,18>>
%   <<16#12345678:32/native>>, % <<120,86,52,18>>
%   <<16#12345678:32>> % <<18,52,86,120>>
% }.

% Sign :: signed | unsigned  % defaults to unsigned, used in patter mattching
% Type :: integer | float | binary | bytes | bitstring | bits | utf8/16/32
% ^^^ Defaults to integer
% Unit :: unit:1|2|...|256
% -- Defaults to 1: for integer, float, bitstring.
% -- Defaults to 8: binary
% -- No Value For: utfX
% Total Size of Segment = Size * Unit

