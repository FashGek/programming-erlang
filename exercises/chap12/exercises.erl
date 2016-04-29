-module(exercises).

-export([start/2]).
-export([listen/0]).
-export([benchmark_processes/1]).


%% Exercise 1

start(Atom, Function) ->
    case whereis(Atom) of
        undefined ->
            register(Atom, spawn(Function));
        _ ->
            {ko, atom_already_registered}
    end.

listen() ->
    receive
        _ ->
            void
    end.

%% Exercise 2

benchmark_processes(NumberOfProcesses) ->
    ProcessesLimit = erlang:system_info(process_limit),
    io:format("Maximum allowed process is: ~p~n", [ProcessesLimit]),
    [max(X) || X <- lists:seq(1, NumberOfProcesses)].

max(N) ->
    statistics(runtime),
    statistics(wall_clock),
    Processes = for(1, N, fun() -> spawn(?MODULE, listen, []) end),
    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    lists:foreach(fun(Process) -> Process ! die end, Processes),
    U1 = Time1 * 1000 / N,
    U2 = Time2 * 1000 / N,
    {N, U1, U2}.

for(1, 1, Function) -> [Function()];
for(I, N, Function) -> for(I + 1, N, Function, [Function()]).

for(I, N, Function, Acc) when I < N -> for(I + 1, N, Function, [Function()|Acc]);
for(N, N, Function, Acc) -> [Function()|Acc].

%% Exercise 3

%% See ring.erl
