-module(stimer).

-export([start/2]).
-export([cancel/1]).


start(Timeout, Function) ->
    spawn(fun() -> timer(Timeout, Function) end).

cancel(TimerPid) ->
    TimerPid ! stop.

timer(Timeout, Function) ->
    receive
        stop ->
            void
    after Timeout ->
            Function()
    end.
