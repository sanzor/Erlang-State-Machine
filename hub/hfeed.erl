-module(hfeed).
-behaviour(gen_event).


-compile(export_all).

-record(state,{
    toPid,
    events=[]
}).

init(Pid)->
    {ok,#state{toPid=Pid}}.
handle_event(Event,State=#state{toPid=Pid,events=Ms})->
    Pid ! Event,
    Ns=[Event | Ms],
    {ok,State#state{events=Ns}}.

handle_call(show_all,State)->{ok,State#state.events,State}.

    

