-module(binaries).

-export([reverse/1, reverse2/1, term_to_packet/1, packet_to_term/1]).
-export([test_term_to_packet/0, test_packet_to_term/0]).

% First exercise

reverse(Bin) ->
    reverse_helper(Bin, byte_size(Bin), <<>>).

reverse_helper(_, 0, Reversed) ->
    Reversed;
reverse_helper(Bin, Length, Reversed) ->
    Byte = binary:at(Bin, Length - 1),
    reverse_helper(Bin, Length - 1, <<Reversed/binary, Byte>>).


reverse2(Bin) ->
    reverse2(Bin, <<>>).

reverse2(<<>>, Acc) ->
    Acc;
reverse2(<<Head:1/binary, Rest/binary>>, Acc) ->
    reverse2(Rest, <<Head/binary, Acc/binary>>).

% Second exercise

term_to_packet(Term) ->
    Binary = term_to_binary(Term),
    Length = byte_size(Binary),
    <<Length:32/integer, Binary:Length/binary>>.

% Third exercise

packet_to_term(<<Length:32/integer, Binary:Length/binary>>) ->
    binary_to_term(Binary).

% Fourth exercise

test_term_to_packet() ->
    Term = i_am_a_term,
    Binary = term_to_binary(Term),
    Length = byte_size(Binary),
    <<Length:32/integer, Binary:Length/binary>> = term_to_packet(Term),
    test_pass.

test_packet_to_term() ->
    Term = i_am_a_term,
    Packet = term_to_packet(Term),
    Term = packet_to_term(Packet),
    test_pass.
