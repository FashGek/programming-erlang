-module(mymaps).

-export([invert/1, has_value/2]).

invert(Map) when is_map(Map) ->
    invert(maps:to_list(Map), maps:new()).

invert([], NewMap) ->
    NewMap;
invert([{K,V}|T], NewMap) ->
    invert(T, maps:put(V,K,NewMap)).

has_value(V, Map) ->
    has_value_helper(V, maps:to_list(Map)).

has_value_helper(_, []) ->
    false;
has_value_helper(V, [{_,V}|_]) ->
    true;
has_value_helper(V, [{_,_}|T]) ->
    has_value_helper(V, T).
