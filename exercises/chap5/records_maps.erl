-module(records_maps).

-export([map_search_pred/2]).

map_search_pred(Map, Pred) ->
    map_search_pred_helper(maps:to_list(Map), Pred).

map_search_pred_helper([], _) -> {};
map_search_pred_helper([H = {Key, Value}|T], Pred) ->
    case Pred(Key, Value) of
        true -> H;
        false -> map_search_pred_helper(T, Pred)
    end.

