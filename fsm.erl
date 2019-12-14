-module(fsm).
-record(state,{
    current="None",
    intvCount=0,
    jobCount=0
}).
-export([init/1,terminate/3,callback_mode/0,code_change/4]).

-export([state/1,start/0,hire/2,fire/2,interview/2]).

-export([sitting_home/3,interviewing/3,working/3]).

-behaviour(gen_statem).

%API
start()->
    gen_statem:start_link(?MODULE,[],[]).
state(PID)->
    gen_statem:call(PID,state,0).
hire(PID,Company)->
    gen_statem:call(PID,{hire,Company},0).
fire(PID,Company)->
    gen_statem:call(PID,{fire,Company},0).
interview(PID,Company)->
    gen_state:call(PID,{intv,Company},0).

%mandatory
code_change(V,State,Data,Extra)->{ok,State,Data}.
callback_mode() ->
    [state_functions,handle_event_function].
init([])->
    {ok,sitting_home,#state{current="None",jobCount=0,intvCount=0}}.
terminate(Reasom,State,Data)->
    void.

% Generic handlers
handle_event({call,From},state,State)->
    {keep_state,State,[{reply,From,State}]};
handle_event(_,_,State)->
    {keep_state,State}.

% State implementations
sitting_home({call,From},{intv,Company},State=#state{intvCount=C})->
     {next_state,interviewing,State#state{intvCount=C+1},[{reply,From,"Interviewing by:"++Company}]};
sitting_home(EventType,Event,State)->
     handle_event(EventType,Event,State).
interviewing({call,From},{rejected,Company},State)->
    {next_state,sitting_home,State,[{reply,From,"rejected by:"++Company}]};
interviewing({call,From},{accepted,Company},State=#state{jobCount=J})->
    {next_state,
    working,
    State#state{jobCount=J+1,current=Company},
    [{reply,From,"accepted offer from:"++Company}]
};
interviewing(EventType,Event,State)->
    handle_event(EventType,Event,State).


working({call,From},{fire,Company},State=#state{current=C})->
    {next_state,working,State#state{current="None"},[{reply,From,"Got fired from"++Company}]};
working(EventType,Event,State)->
      handle_event(EventType,Event,State).








