-module(kvs).

-export([start/0, stop/0]).

-export([store/2]).
-export([lookup/1]).

start() ->
    case whereis(?MODULE) of
        undefined ->
            register(?MODULE, spawn(fun() -> loop() end));
        _ ->
            ok
    end.

stop() ->
    case whereis(?MODULE) of
        undefined ->
            not_running;
        Pid ->
            exit(Pid, kill)
    end.

store(Key, Value) ->
    rpc({store, Key, Value}).

lookup(Key) ->
    rpc({lookup, Key}).


%% private functions

rpc(Request) ->
    ?MODULE ! {self(), Request},
    receive
        {?MODULE, Response} ->
            Response;
        _ ->
            error
    end.

loop() ->
    receive
        {From, Request} ->
            Response = handle_request(Request),
            From ! {?MODULE, Response},
            loop();
        _ ->
            loop()
    end.

handle_request({store, Key, Value}) ->
    put(Key, Value),
    ok;

handle_request({lookup, Key}) ->
    get(Key).
