-module(fsm).
-record(state,{
    current="None",
    intvCount=0,
    jobCount=0,
    monitor
}).
-export([init/1,start/0]).
-export([hire/2,fire/1,interview/2]).

-behaviour(gen_statem).


start()->
    gen_statem:start(?MODULE,[self()],[]).

init(Monitor)->
    {ok,sitting_home,#state{current="None",jobCount=0,intvCount=0,monitor=Monitor}}.

sitting_home({intv,Company},State=#state{intvCount=C,monitor=M})->
     gen_statem:reply(M,"Got an interview from:"++Company++" going interviewing"),
     {next_state,interviewing,State#state{intvCount=C+1}};
sitting_home(Event,State)->
     gen_statem:reply(State#state.monitor,{unexpected , Event}),
     {next_state,sitting_home,State}.

interviewing({rejected,Company},State)->
    gen_statem:reply("Booh got rejected by :"++ Company),
    {next_state,sitting_home,State};
interviewing({accepted,Company},State=#state{jobCount=J})->
    gen_statem:reply("Hooray got accepted"),
    {next_state,working,State#state{jobCount=J+1,current=Company}};
interviewing(_,State)->
    gen_statem:reply("Unknown message"),
    {next_state,interviewing,State}.


working(fire,State=#state{current=C})->
    gen_statem:reply("Unexpected event"),
    {next_state,working,State#state{current="None"}};
working(Event,State)->
        gen_statem:reply("Unexpected event"),
        {next_state,working,State}.

hire(Company,PID)->
    gen_statem:sync_send_event(PID,{hire,self(),Company},0).
fire(PID)->
    gen_statem:sync_send_event(PID,{fire,self()},0).
interview(Company,PID)->
    gen_state:sync_send_event(PID,{intv,Company},0).







