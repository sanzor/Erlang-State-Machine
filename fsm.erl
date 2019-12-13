-module(fsm).
-record(state,{
    current="None",
    intvCount=0,
    jobCount=0
}).
-export([init/1,start/0,callback_mode/0,something/2]).
-export([hire/2,fire/1,interview/2]).

-export([sitting_home/3,interviewing/3,working/3]).



-behaviour(gen_statem).

something("Adrian",tu)->
    {amount,300};
something(_,_)->
    {33.5}.


callback_mode() ->
    state_functions.

start() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).

init([])->
    {ok,sitting_home,#state{current="None",jobCount=0,intvCount=0}}.

sitting_home({call,From},{intv,Company},State=#state{intvCount=C})->
     gen_statem:reply(From,"Got an interview from:"++Company++" going interviewing"),
     {next_state,interviewing,State#state{intvCount=C+1}};
sitting_home({call,From},Event,State)->
     gen_statem:reply(From,{unexpected , Event}),
     {next_state,sitting_home,State}.

interviewing({call,From},{rejected,Company},State)->
    gen_statem:reply(From,"Booh got rejected by :"++ Company),
    {next_state,sitting_home,State};
interviewing({call,From},{accepted,Company},State=#state{jobCount=J})->
    gen_statem:reply(From,"Hooray got accepted"),
    {next_state,working,State#state{jobCount=J+1,current=Company}};
interviewing({call,From},_,State)->
    gen_statem:reply(From,"Unknown message"),
    {next_state,interviewing,State}.


working({call,From},fire,State=#state{current=C})->
    gen_statem:reply("Unexpected event"),
    {next_state,working,State#state{current="None"}};
working({call,From},Event,State)->
        gen_statem:reply("Unexpected event"),
        {next_state,working,State}.

hire(Company,PID)->
    gen_statem:sync_send_event(PID,{hire,self(),Company},0).
fire(PID)->
    gen_statem:sync_send_event(PID,{fire,self()},0).
interview(Company,PID)->
    gen_state:sync_send_event(PID,{intv,Company},0).







