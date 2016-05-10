-module(lib_misc).

-export([on_exit/2]).

-export([echo/0]).

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
