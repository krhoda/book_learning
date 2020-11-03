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

% Pixel example:
% Using 16 bits, we can represent color.
% 5 bits for Red
% 6 bits for Green
% 5 bits for Blue
% We could define a pixel as follows:
% > Red = 2.
% > Green = 61.
% > Blue = 20.
% > Mem = <<Red:5, Green:6, Blue:5>>.
% -> <<23,180>>
% This is a 2 byte binary containing a 16 bit quantity.
% Now we can pattern match:
% <<R:5, G:6, B:5>> = Mem.
% R =:= 2
% G =:= 61
% B =:= 20

% Bit Strings v. Binaries (The former has no restriction, the latter
% must be bytes).
% > B1 = <<1:8>>.
% -> <<1>>
% B1 is a binary containing a representation of the number 1
% > byte_size(B1).
% -> 1
% > is_binary(B1).
% -> true
% > is_bitstring(B1).
% -> true
% B2 = <<1:17>>.
% -> <<0,0,1:1>>
% B2 is a bit string containing 17 bits (2 8 bit bytes, 1 bitstring of len 1)

% Now for the AWESOME part
% BIT COMPREHENSIONS:
% <= for binary, <- for lists.

% > B = <<16#5f>>
% -> <<"_">>
% 5f is the hexidecimal representation of underscore.
% > [X || <<X:1>> <= B].
% -> [0,1,0,1,1,1,1,1]
% to get a Binary instead of a list:
% > << <<X>> || <<X:1>> <= B >>.


