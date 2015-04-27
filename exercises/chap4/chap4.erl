-module(chap4).

-export([my_tuple_to_list/1]).

my_tuple_to_list(T) ->
    my_tuple_to_list(size(T), T, []).

my_tuple_to_list(0, _, Acc) ->
    Acc;
my_tuple_to_list(Size, T, Acc) ->
    Element = element(Size, T),
    my_tuple_to_list(Size - 1, T, [Element|Acc]).


