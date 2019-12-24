-module(mgr).
-import(h0,[]).
-import(h1,[]).
-export([start/0,addh/2]).

start()->
    {ok,Pid}=gen_event:start_link({local,?MODULE}),
    Pid.

addh(Type,Pid)->
    %Ref=make_ref(),
    gen_event:add_handler(Pid,Type,[]).
   