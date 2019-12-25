-module(mgr).
-import(h1,[init/1]).
-export([start/0,addh/2]).

start()->
    ServerName=mgr,
    {ok,Pid}=gen_event:start_link({local,?MODULE}),
    Pid.

addh(Type,Pid)->
    CBModule=Type,
    io:format("CB Name= ~p",[CBModule]),
    %Ref=make_ref(),
    gen_event:add_handler(?MODULE,CBModule,[]).
   