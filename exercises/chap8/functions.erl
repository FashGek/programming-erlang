-module(functions).

-export([how_many_exports/0, module_with_most_functions/1]).

% First exercise

how_many_exports() ->
    length(dict:module_info(exports)).

% Second exercise
% Write functions to determine which module exports the most functions
module_with_most_functions(Modules) ->
    module_with_most_functions(Modules, {nothing, 0}).

module_with_most_functions([], Acc) ->
    Acc;
module_with_most_functions([{CurrentModule, _}|Modules], Acc = {_, ModuleExports}) ->
    CurrentModuleExports = length(CurrentModule:module_info(exports)),
    case CurrentModuleExports > ModuleExports of
        true -> module_with_most_functions(Modules, {CurrentModule, CurrentModuleExports});
        _  -> module_with_most_functions(Modules, Acc)
    end.

% Third exercise
% Which function name is the most common

%TODO

% Fourth exercise
% Write a function to find all unambiguous function names, that
% is, function names that are used in only one module

%TODO
