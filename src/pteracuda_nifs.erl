-module(pteracuda_nifs).

-define(NIF_API_VERSION, 1).
-define(MISSING_NIF, throw({error, missing_nif})).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-on_load(init/0).

-export([init/0]).

%% API
-export([new_worker/0,
         destroy_worker/1,
         new_buffer/1,
         destroy_buffer/1]).

new_worker() ->
    ?MISSING_NIF.

destroy_worker(_Worker) ->
    ?MISSING_NIF.

new_buffer(_Worker) ->
    ?MISSING_NIF.

destroy_buffer(_Worker) ->
    ?MISSING_NIF.


init() ->
    PrivDir = case code:priv_dir(pteracuda) of
                  {error, bad_name} ->
                      D = filename:dirname(code:which(?MODULE)),
                      filename:join([D, "..", "priv"]);
                  Dir ->
                      Dir
              end,
    SoName = filename:join([PrivDir, "pteracuda_nifs"]),
    erlang:load_nif(SoName, ?NIF_API_VERSION).

-ifdef(TEST).

create_destroy_test() ->
    {ok, W} = pteracuda_nifs:new_worker(),
    ok = pteracuda_nifs:destroy_worker(W),
    %% Can destroy a worker just once
    error = pteracuda_nifs:destroy_worker(W).

int_alloc_destroy_test() ->
    {ok, W} = pteracuda_nifs:new_worker(),
    ok = pteracuda_nifs:new_buffer(W),
    ok = pteracuda_nifs:destroy_buffer(W),
    %% Can destroy a buffer just once
    error = pteracuda_nifs:destroy_buffer(W),
    ok.

-endif.
