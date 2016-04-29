-module(ring).

-export([benchmark_ring/2]).

benchmark_ring(NumberOfMessages, RingSize) ->
    create_ring(RingSize),
    send_bulk_messages(NumberOfMessages).

send_bulk_messages(0) -> messages_sent;
send_bulk_messages(Number) ->
    send_message_to(p0, "a message"),
    send_bulk_messages(Number - 1).

create_ring(Size) ->
    [create_ring_process(Id, Size) || Id <- lists:seq(0, Size - 1)].

create_ring_process(Id, MaxHops) ->
    ProcessName = process_name_for(Id),
    Pid = whereis(ProcessName),
    case Pid of
        undefined ->
            register(ProcessName, spawn(fun() -> ring_process(Id, MaxHops) end));
        _ ->
            send_resize_to(Pid, MaxHops)
    end.

ring_process(Id, MaxHops) ->
    receive
        {message, Hop, Message} when Hop < MaxHops ->
            io:format("~p/~p: hop [~p] received message [~p]~n", [self(), Id, Hop, Message]),
            forward_message_from(Id, Hop, MaxHops, Message),
            ring_process(Id, MaxHops);
        {resize, NewMaxHops} ->
            io:format("~p/~p: resizing MaxHops to [~p]~n", [self(), Id, NewMaxHops]),
            ring_process(Id, NewMaxHops);
        _ ->
            io:format("~p/~p: nothing to do~n", [self(), Id]),
            ring_process(Id, MaxHops)
    end.

forward_message_from(Id, Hop, MaxHops, Message) ->
    case Hop + 1 < MaxHops of
        true ->
            NextId = next_of(Id, MaxHops),
            NextName = process_name_for(NextId),
            Next = whereis(NextName),
            Next ! {message, Hop + 1, Message};
        _ ->
            false
    end.

process_name_for(Number) ->
    list_to_atom("p" ++ integer_to_list(Number)).

next_of(Number, Max) when Number + 1 < Max -> Number + 1;
next_of(_, _) -> 0.

send_message_to(Pid, Message) ->
    Pid ! {message, 0, Message}.

send_resize_to(Pid, MaxHops) ->
    Pid ! {resize, MaxHops}.
