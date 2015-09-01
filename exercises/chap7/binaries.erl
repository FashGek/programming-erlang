-module(binaries).

-export([reverse/1]).

reverse(Bin) ->
    reverse_helper(Bin, byte_size(Bin), <<>>).

reverse_helper(_, 0, Reversed) ->
    Reversed;
reverse_helper(Bin, Length, Reversed) ->
    Byte = binary:at(Bin, Length - 1),
    reverse_helper(Bin, Length - 1, <<Reversed/binary, Byte>>).
