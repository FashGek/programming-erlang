-module(math_functions).

-export([even/1, odd/1, filter/2, split/1, split2/1]).

even(Number) ->
    Number rem 2 == 0.

odd(Number) ->
    not even(Number).

filter(F, List) ->
    [Element || Element <- List, F(Element)].

split(List) ->
    Even = filter(fun(X) -> even(X) end, List),
    Odd = filter(fun(X) -> odd(X) end, List),
    {Even, Odd}.

split2(List) ->
    split(List, [], []).

split([], Even, Odd) ->
    {lists:reverse(Even), lists:reverse(Odd)};

split([H|T], Even, Odd) ->
    case even(H) of
        true -> split(T, [H|Even], Odd);
        false -> split(T, Even, [H|Odd])
    end.
