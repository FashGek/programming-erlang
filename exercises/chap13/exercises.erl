-module(exercises).

-export([my_spawn_start/3]).
-export([my_spawn/3]).

-export([on_exit/2]).

-export([my_spawn_start/4]).
-export([my_spawn/4]).

-export([die_after/1]).

-export([test_ex4/0]).
-export([monitor_respawn/3]).
-export([monitor_respawn_start/3]).

-export([monitor_fleet_start/1]).
-export([respawn/3]).
-export([test_ex5/0]).

-export([one_for_all_start/1]).
-export([one_for_all/1]).
-export([test_ex6/0]).

-export([im_still_running/0]).


%% Exercise 1

my_spawn_start(Mod, Func, Args) ->
    spawn(?MODULE, my_spawn, [Mod, Func, Args]).

my_spawn(Mod, Func, Args) ->
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

my_spawn_start(Mod, Func, Args, Seconds) ->
    spawn(?MODULE, my_spawn, [Mod, Func, Args, Seconds]).

my_spawn(Mod, Func, Args, Seconds) ->
    {Pid, Ref} = spawn_monitor(Mod, Func, Args),
    Start = erlang:monotonic_time(),
    receive
        {'DOWN', Ref, process, Pid, Why} ->
            Stop = erlang:monotonic_time(),
            Duration = erlang:convert_time_unit(Stop - Start, native, milli_seconds),
            io:format("The Pid ~p has exited with [~p], total duration of: ~p ms !~n", [Pid, Why, Duration])
    after
        Seconds * 1000 ->
            exit(Pid, timeout)
    end.

%% Exercise 4

test_ex4() ->
    monitor_respawn_start(?MODULE, im_still_running, []),
    timer:sleep(1000),
    Pid = whereis(im_still_running),
    io:format("Current Pid is: ~p~n", [Pid]),
    timer:sleep(12000),
    exit(Pid, crash),
    timer:sleep(1000),
    NewPid = whereis(im_still_running),
    io:format("New Pid is: ~p~n", [NewPid]).

monitor_respawn_start(Mod, Fun, Args) ->
    spawn(?MODULE, monitor_respawn, [Mod, Fun, Args]).

monitor_respawn(Mod, Fun, Args) ->
    {Pid, Ref} = spawn_monitor(Mod, Fun, Args),
    register(im_still_running, Pid),
    receive
        {'DOWN', Ref, process, Pid, _Why} ->
            io:format("Re-spawning process ...~n", []),
            monitor_respawn(Mod, Fun, Args)
    end.

%% Exercise 5

monitor_fleet_start(Funs) ->
    [spawn(?MODULE, respawn, [Mod, Fun, Args]) || {Mod, Fun, Args} <- Funs].

respawn(Mod, Fun, Args) ->
    {Pid, Ref} = spawn_monitor(Mod, Fun, Args),
    receive
        {'DOWN', Ref, process, Pid, Why} ->
            io:format("Re-spawning process that exited with: ~p~n", [Why]),
            respawn(Mod, Fun, Args)
    end.

test_ex5() ->
    Funs = [
            {?MODULE, die_after, [2000]},
            {?MODULE, die_after, [4000]},
            {?MODULE, die_after, [6000]},
            {?MODULE, die_after, [7000]},
            {?MODULE, die_after, [8000]}
           ],
    monitor_fleet_start(Funs).

%% Exercise 6

one_for_all_start(Funs) ->
    spawn(?MODULE, respawn, [?MODULE, one_for_all, [Funs]]).

one_for_all(Funs) ->
    [spawn_link(Mod, Fun, Args) || {Mod, Fun, Args} <- Funs],
    receive
        _ -> continue
    end.

test_ex6() ->
    Funs = [
            {?MODULE, die_after, [2000]},
            {?MODULE, die_after, [4000]},
            {?MODULE, die_after, [6000]},
            {?MODULE, die_after, [7000]},
            {?MODULE, die_after, [8000]}
           ],
    one_for_all_start(Funs).

%% Utility code

die_after(Timeout) ->
    io:format("I'm up with PID: [~p] / timeout: [~pms]~n", [self(), Timeout]),
    receive
    after
        Timeout ->
            io:format("I'm died with PID: [~p] / after [~p]ms~n", [self(), Timeout]),
            exit(im_died)
    end.

im_still_running() ->
    io:format("I'm still running~n"),
    receive
    after
        5000 ->
            im_still_running()
    end.
