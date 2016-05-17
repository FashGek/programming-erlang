-module(exercises).

-export([my_spawn/3]).
-export([my_spawn_monitor/3]).

-export([on_exit/2]).

-export([my_spawn/4]).
-export([my_spawn_monitor/4]).

-export([die_after/1]).

-export([test_ex4/0]).
-export([monitor_respawn/3]).
-export([monitor_respawn_start/3]).

-export([im_still_running/0]).


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

%% Exercise 4

test_ex4() ->
    monitor_respawn(?MODULE, im_still_running, []),
    timer:sleep(1000),
    Pid = whereis(im_still_running),
    io:format("Current Pid is: ~p~n", [Pid]),
    timer:sleep(12000),
    exit(Pid, crash),
    timer:sleep(1000),
    NewPid = whereis(im_still_running),
    io:format("New Pid is: ~p~n", [NewPid]).

monitor_respawn(Mod, Fun, Args) ->
    spawn(?MODULE, monitor_respawn_start, [Mod, Fun, Args]).

monitor_respawn_start(Mod, Fun, Args) ->
    {Pid, Ref} = spawn_monitor(Mod, Fun, Args),
    register(im_still_running, Pid),
    receive
        {'DOWN', Ref, process, Pid, _Why} ->
            io:format("Re-spawning process ...~n", []),
            monitor_respawn_start(Mod, Fun, Args)
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

im_still_running() ->
    io:format("I'm still running~n"),
    receive
    after
        5000 ->
            im_still_running()
    end.
