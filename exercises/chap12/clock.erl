-module(clock).

-export([start/2]).
-export([stop/0]).

start(Timeout, Function) ->
    ClockProcess = spawn(fun() -> tick(Timeout, Function) end),
    register(clock, ClockProcess).

stop() ->
    clock ! stop.

tick(Timeout, Function) ->
    receive
        stop ->
            void
    after Timeout ->
            Function(),
            tick(Timeout, Function)
    end.
