-module(timeouts).

-export([sleep/1]).

sleep(Timeout) ->
    receive
    after Timeout -> timed_out
    end.
