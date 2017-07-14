-module(kvs_tests).

-include_lib("eunit/include/eunit.hrl").

kvs_test_() ->
    {setup,
     fun start/0,
     fun stop/1,
     fun (SetupData) ->
             [starts_the_kvs_server(SetupData),
              store_returns_true_when_a_value_is_stored(SetupData),
              lookup_returns_undefined_when_key_does_not_exists(SetupData),
              lookup_returns_value_when_key_exists(SetupData)
             ]
     end
    }.

start() ->
    kvs:start().

stop(_) ->
    kvs:stop().

starts_the_kvs_server(_) ->
    [?_assertNotEqual(undefined, whereis(kvs))].

store_returns_true_when_a_value_is_stored(_) ->
    Result = kvs:store(key, "a value"),
    [?_assertEqual(ok, Result)].

lookup_returns_undefined_when_key_does_not_exists(_) ->
    Result = kvs:lookup(not_existing_key),
    [?_assertEqual(undefined, Result)].

lookup_returns_value_when_key_exists(_) ->
    kvs:store(key, "a value"),
    Result = kvs:lookup(key),
    [?_assertEqual("a value", Result)].
