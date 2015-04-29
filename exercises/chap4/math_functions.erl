-module(math_functions).

-export([even/1, odd/1]).

even(Number) ->
    Number rem 2 == 0.

odd(Number) ->
    not even(Number).
