# KVS

A simple implementation in Erlang of a Key-Value Store


## How to compile

```
$ erlc kvs.erl kvs_tests.erl
```

## How to run tests

I've tried to use EUnit

```
$ erl -noshell -eval "eunit:test(kvs_tests, [verbose])" -s init stop
```

## How to try the KVS

```
$ erl -eval "kvs:start()"

...

> kvs:store(hello, "hello").
> kvs:lookup(hello).
```
