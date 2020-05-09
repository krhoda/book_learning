-module(street).
-export([make_house/2, show_street/0, show_address/0]).

make_house(Address, Direction) ->
    {house, {address, Address, Direction}}.

make_street(Number, List) -> 
    case Number >= 0 of
        true -> make_street(Number - 1, [make_house(Number, make_direction(Number)) | List]);
        false -> List
    end.

make_direction(Number) ->
    case Number rem 2 of
        0 -> "W";
        _ -> "E"
    end.

show_street() -> make_street(10, []).

show_address() -> 
    Street = show_street(),
    build_address(Street, []).

build_address(Street, List) ->
    case Street of
        [] -> List;
        [{house, {address, Num, Dir}} | Xs] -> build_address(Xs, [{Num, Dir} | List])
    end.