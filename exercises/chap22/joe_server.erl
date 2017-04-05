-module(joe_server).

-export([start/2]).

start(Name, Mod) ->
    register(Name, spawn(fun() -> loop(Name, Mod, []) end)).

loop(Name, Mod, State) ->
    receive
        {From, Request} ->
            {Response, NextState} = Mod:handle(Request, State),
            From ! {Name, Response},
            loop(Name, Mod, NextState)
    end.
