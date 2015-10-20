-module(functions).

-export([how_many_exports/1]).

how_many_exports([]) ->
    nothing;
how_many_exports([{exports, List}|_]) ->
    {ok, length(List)};
how_many_exports([{_, _}|T]) ->
    how_many_exports(T).
