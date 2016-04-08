-module(client_server).

-export([loop/0]).
-export([start/0]).
-export([send/2]).

send(To, Request) ->
    To ! {self(), Request},
    receive
        {To, Response} ->
            Response
    end.

start() ->
    spawn(client_server, loop, []).

loop() ->
    receive
        {From, {rectangle, Height, Width}} ->
            Area = Height * Width,
            From ! {self(), {ok, Area}},
            loop();
        {From, {square, Side}} ->
            Area = Side * Side,
            From ! {self(), {ok, Area}},
            loop();
        {From, _} ->
            From ! {self(), {ko, bad_request}},
            loop()
    end.
