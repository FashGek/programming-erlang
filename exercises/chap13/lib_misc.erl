-module(lib_misc).

-export([on_exit/2]).

-export([echo/0]).

-export([keep_alive/3]).
-export([die_after/1]).

on_exit(Pid, Fun) ->
    spawn(fun() ->
                  Ref = monitor(process, Pid),
                  receive
                      {'DOWN', Ref, process, Pid, Why} ->
                          Fun(Why)
                  end
          end).

echo() ->
    receive
        Message ->
            list_to_atom(Message)
    end.

keep_alive(Module, Function, Args) ->
    Pid = spawn(Module, Function, Args),
    on_exit(Pid, fun(_Why) -> keep_alive(Module, Function, Args) end).

die_after(Timeout) ->
    io:format("I'm up with PID: [~p]~n", [self()]),
    receive
    after
        Timeout ->
            io:format("I'm down with PID: [~p]~n", [self()]),
            done
    end.
