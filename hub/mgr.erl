-module(mgr).
-import([h0,h1]).

start(HandlerType)->
    {ok,Pid}=gen_event:start_link({local,?MODULE}),
    Ref=make_ref(),
    gen_event:add_handler(Pid,{HandlerType,Ref},[]),
    Pid.