-module(ws_handler).
-behaviour(cowboy_websocket_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
    % io:format("========================>init ~n"),
    {upgrade, protocol, cowboy_websocket};
init({ssl, http}, _Req, _Opts) ->
    % io:format("========================>ssl init ~n"),
    {upgrade, protocol, cowboy_websocket}.    

websocket_init(_TransportName, Req, _Opts) ->
    % io:format("========================>websocket_init ~n"),
    erlang:start_timer(5000, self(), <<"Hello!">>),
    {ok, Req, undefined_state}.

websocket_handle({text, Msg}, Req, State) ->
    % io:format("=========> websocket_handle Req:~p Msg:~p~n", [Req, Msg]),
    {reply, {text, << "That's what she said! ", Msg/binary >>}, Req, State};
websocket_handle(_Data, Req, State) ->
    {ok, Req, State}.


websocket_info({timeout, _Ref, Msg}, Req, State) ->
   % io:format("=========> websocket_info _Ref:~p Msg:~p~n", [_Ref, Msg]),
    erlang:start_timer(5000, self(), <<"How' you doin'?">>),
    {reply, {text, Msg}, Req, State};
websocket_info(_Info, Req, State) ->
    {ok, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
    ok.
