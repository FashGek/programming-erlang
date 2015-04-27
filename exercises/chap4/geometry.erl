-module(geometry).

-export([area/1, perimeter/1]).

area({rectangle, Width, Height}) ->  Width * Height;
area({square, Side}) -> Side * Side;
area({circle, Radius}) -> math:pi() * math:pow(Radius, 2);
area({right_angled_triangle, Width, Height}) -> area({rectangle, Width, Height}) / 2.

perimeter({rectangle, Width, Height}) ->  Width * 2 + Height * 2;
perimeter({square, Side}) -> Side * 4;
perimeter({circle, Radius}) -> 2 * math:pi() * Radius;
perimeter({right_angled_triangle, Width, Height}) -> Width + Height + math:sqrt(math:pow(Width,2) + math:pow(Height,2)).
