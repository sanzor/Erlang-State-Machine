-module(fsm).
-record(data,{
    current="None",
    intvCount=0,
    jobCount=0
}).
-export([init/1,terminate/3,callback_mode/0,code_change/4]).

-export([state/1,start/0,hire/2,fire/2,interview/2]).

-export([sitting_home/3,interviewing/3,working/3]).
-export([handle_event/3]).
-behaviour(gen_statem).

handle_event({call,From},get_state,Data)->
    {keep_state,Data,[{reply,Data}]};
handle_event({call,From},Event,Data)->
    {keep,state,Data}.
%API
start()->
    gen_statem:start_link(?MODULE,[],[]).
state(PID)->
    gen_statem:call(PID,get_state).
hire(PID,Company)->
    gen_statem:call(PID,{hire,Company}).
fire(PID,Company)->
    gen_statem:call(PID,{fire,Company}).
interview(PID,Company)->
    gen_statem:call(PID,{intv,Company}).

%mandatory
code_change(V,State,Data,Extra)->{ok,State,Data}.
callback_mode() ->
    state_functions,.
init([])->
    {ok,sitting_home,#data{current="None",jobCount=0,intvCount=0}}.
terminate(Reasom,State,Data)->
    void.

% State implementations
sitting_home({call,From},{intv,Company},Data=#data{intvCount=C})->
    io:format("sugi pl"),
    {next_state,interviewing,Data#data{intvCount=C+1}};
sitting_home({call,From},Event,Data)->
    {keep_state,Data}.
interviewing({call,From},{rejected,Company},Data)->
    {next_state,sitting_home,Data};
interviewing({call,From},{accepted,Company},State=#data{jobCount=J})->
    {next_state,working,State#data{jobCount=J+1,current=Company}};
interviewing(EventType,Event,Data)->
    {keep_state,Data}.


working({call,From},{fire,Company},Data=#data{current=C})->
    {next_state,working,Data#data{current="None"},[{reply,From,"Got fired from"++Company}]};
working(EventType,Event,Data)->
    {keep_state,Data}.








