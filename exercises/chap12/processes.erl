-module(processes).

-export([max/1]).

max(N) ->
    ProcessesLimit = erlang:system_info(process_limit),
    io:format("Maximum allowed process is: ~p~n", [ProcessesLimit]),
    statistics(runtime),
    statistics(wall_clock),
    Processes = for(1, N, fun() -> spawn(fun() -> wait() end) end),
    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    lists:foreach(fun(Process) -> Process ! die end, Processes),
    U1 = Time1 * 1000 / N,
    U2 = Time2 * 1000 / N,
    io:format("Processe spawn time=~p (~p) microseconds~n", [U1, U2]).

for(N, N, Function) -> [Function()];
for(I, N, Function) -> [Function()|for(I + 1, N, Function)].

wait() ->
    receive
        die -> bye
    end.
