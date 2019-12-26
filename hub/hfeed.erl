-module(hfeed).
-behaviour(gen_event).


-behaviour(gen_event).

-record(state,{
    toPid,
    events=[]
}).

init(Pid)->
    {ok,#state{toPid=Pid}}.
handle_event(Event,State=#state{toPid=Pid,messsages=Ms})->
    Pid ! Event,
    Ns=[Event | Ms],
    {ok,State#state{messages=Ns}}.

