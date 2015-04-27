-module(lib_misc).

-export([my_tuple_to_list/1, my_time_func/1]).

my_tuple_to_list(T) ->
    my_tuple_to_list(size(T), T, []).

my_tuple_to_list(0, _, Acc) ->
    Acc;
my_tuple_to_list(Size, T, Acc) ->
    Element = element(Size, T),
    my_tuple_to_list(Size - 1, T, [Element|Acc]).

my_time_func(F) ->
    Start = now(),
    F(),
    End = now(),
    timer:now_diff(End, Start).

