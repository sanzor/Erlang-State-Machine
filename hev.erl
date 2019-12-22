-module(hev).
-export([start/0,append/2,drop/1,state/1]).
-export([init/1,terminate/2,code_change/3,handle_call/2,handle_event/2]).
-record(state,{
    xs=[]
}).
-behaviour(gen_event).

%callbacks
init([])->
    {ok,#state{xs=[1]}}.

terminate()->
    void.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
handle_info(_, State) -> {ok, State}.

%API

start()->
    {ok,Pid}=gen_event:start_link({local,?MODULE}),
    Ref=make_ref(),
    gen_event:add_handler(Pid,{hev,Ref},[]),
    Pid.
append(Pid,Elem)->
    gen_event:notify(Pid,{append,Elem}).
drop(Pid)->
    gen_event:notify(Pid,drop).
state(Pid)->
    gen_event:call(Pid,state).
terminate(Arg,State)->
    ok.
%
handle_event({append,Elem},State=#state{xs=XS})->
    {ok,#state{xs=[Elem|XS]}};
handle_event(drop,State=#state{xs=XS})->
    case XS of
        []->{ok,State};
        [H|T]->{ok,State#state{xs=T}}
    end.

handle_call(state,State)->
    {ok,State,State};
handle_call(Event,State)->
    {ok,nada_for_you,State}.
    



