-module(exercises).

-export([my_spawn/3]).
-export([my_spawn_monitor/3]).

-export([on_exit/2]).

-export([my_spawn/4]).
-export([my_spawn_monitor/4]).

-export([die_after/1]).


%% Exercise 1

my_spawn(Mod, Func, Args) ->
    spawn(?MODULE, my_spawn_monitor, [Mod, Func, Args]).

my_spawn_monitor(Mod, Func, Args) ->
    {Pid, Ref} = spawn_monitor(Mod, Func, Args),
    Start = erlang:monotonic_time(),
    receive
        {'DOWN', Ref, process, Pid, Why} ->
            Stop = erlang:monotonic_time(),
            Duration = erlang:convert_time_unit(Stop - Start, native, milli_seconds),
            io:format("The Pid ~p has exited with [~p], total duration of: ~p ms !~n", [Pid, Why, Duration])
    end.

%% Exercise 2

on_exit(Pid, Fun) ->
    spawn(fun() ->
                  Ref = monitor(process, Pid),
                  Start = erlang:monotonic_time(),
                  receive
                      {'DOWN', Ref, process, Pid, Why} ->
                          Stop = erlang:monotonic_time(),
                          Duration = erlang:convert_time_unit(Stop - Start, native, milli_seconds),
                          Fun(Why, Duration)
                  end
          end).

%% Exercise 3

my_spawn(Mod, Func, Args, Time) ->
    spawn(?MODULE, my_spawn_monitor, [Mod, Func, Args, Time]).

my_spawn_monitor(Mod, Func, Args, Time) ->
    {Pid, Ref} = spawn_monitor(Mod, Func, Args),
    Start = erlang:monotonic_time(),
    receive
        {'DOWN', Ref, process, Pid, Why} ->
            Stop = erlang:monotonic_time(),
            Duration = erlang:convert_time_unit(Stop - Start, native, milli_seconds),
            io:format("The Pid ~p has exited with [~p], total duration of: ~p ms !~n", [Pid, Why, Duration])
    after
        Time * 1000 ->
            exit(Pid, timeout)
    end.

%% Utility code

die_after(Timeout) ->
    io:format("I'm up with PID: [~p]~n", [self()]),
    receive
    after
        Timeout ->
            io:format("I'm down with PID: [~p]~n", [self()]),
            done
    end.
