-module(server).
-record(state,{
    current="None",
    intvCount=0,
    jobCount=0,
    monitor
}).
-export([start_link/0,stop/0]).
-export([hire/2,fire/1]).

-export([init/0,
         hire/1,]).

init(Monitor)->
    {ok,sitting_home,#state{current="None",jobCount=0,intvCount=0,monitor=Monitor}}.

sitting_home({intv,Company},State=#state{intvCount=C,monitor=M})->
     gen_fsm:reply(M,"Got an interview from:"++Company++" going interviewing"),
     {next_state,interviewing,State#state{intvCount=C+1}};
sitting_home(Event,State)->
     gen_fsm:reply(M,{unexpected , Event}),
     {next_state,sitting_home,State}.

interviewing({rejected,Company},State)->
    gen_fsm:reply("Booh got rejected by :"++ Company),
    {next_state,sitting_home,State};
interviewing({accepted,Company},State=#state{jobCount=J})->
    gen_fsm:reply("Hooray got accepted"),
    {next_state,working,State#state{jobCount=J+1,current=Company}}.


working(Event,State)->
    gen_fsm:reply("Unexpected event"),
    {next_state,working,State};
working(fire,State=#state{current=C,count=Cnt})->
    gen_fsm:reply("Unexpected event"),
    {next_state,working,State#state{current="None"}}

intv_call(Name,)
hire(Name,PID)->
    gen_fsm:sync_send_event(PID,{hire,self(),Name},0).

fire(PID)->
    gen:fsm:sync_send_event(PID,{fire,self()},0).






