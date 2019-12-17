-module(fsm).
-record(data,{
    current="None",
    intvCount=0,
    jobCount=0,
    state="None"
}).
-export([init/1,terminate/3,callback_mode/0,code_change/4]).

-export([state/1,start/0,interview/2,reject/2,wait/1]).

-export([sitting_home/3,interviewing/3]).
-export([handle/3]).
-behaviour(gen_statem).

%API
start()->
    gen_statem:start_link(?MODULE,[],[]).
state(PID)->
    gen_statem:call(PID,state).

interview(PID,Company)->
    gen_statem:call(PID,{intv,Company}).
reject(PID,Company)->
    gen_statem:call(PID,{reject,Company}).
wait(PID)->
    gen_statem:call(PID,{wait}).

%mandatory
code_change(V,State,Data,Extra)->{ok,State,Data}.
callback_mode() ->
    state_functions.
init([])->
    {ok,sitting_home,#data{current="None",jobCount=0,intvCount=0}}.
terminate(Reasom,State,Data)->
    void.

% State implementations

sitting_home({call,From},{intv,Company},Data=#data{intvCount=C})->
    {next_state,interviewing,Data#data{intvCount=C+1},[{reply,From,{got_interview,Company}}]};
sitting_home(EventType,Event,Data)->
    handle(EventType,Event,Data).

interviewing({call,From},{rejected,Company},Data)->
    {next_state,interviewing,Data,[{reply,From,{rejected,Company}}]};
interviewing(EventType,Event,Data)->
    handle(EventType,Event,Data).


handle({call,From},state,Data)->
    {keep_state,Data,[{reply,From,Data}]};
handle({call,From},State,Data)->
    {keep_state,Data,[{reply,From,got_nothing_for_you}]};
handle(_,State,Data)->
    {keep_state,Data}.









