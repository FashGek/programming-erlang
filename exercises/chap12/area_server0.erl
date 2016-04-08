-module(area_server0).

-export([loop/0]).

loop() ->
    receive
        {rectangle, Height, Width} ->
            Area = Height * Width,
            io:format("Area of rectangle is ~p~n", [Area]),
            loop();
        {square, Side} ->
            Area = Side * Side,
            io:format("Area of square is ~p~n", [Area]),
            loop();
        _ ->
            io:format("Undefined shape, accepted values area: rectangle and square"),
            loop()
    end.
