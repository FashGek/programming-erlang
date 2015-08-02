-module(error_handling).

-export([open_file/1]).

open_file(Filename) ->
    try file:read_file(Filename) of
        {ok, Bin} -> Bin
    catch
        error:Msg -> throw(Msg)
    end.


