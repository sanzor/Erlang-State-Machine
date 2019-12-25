-module(fsm).
-record(data,{
    current="None",
    intvCount=0,
    jobCount=0,
    positions=[]
}).
-export([init/1,terminate/3,callback_mode/0,code_change/4]).

-export([state/1,start/0,interview/2,reject/2,accept/2,fire/1,promote/2]).

-export([sitting_home/3,interviewing/3,working/3,test/0]).
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
    gen_statem:call(PID,{rejected,Company}).
accept(PID,Company)->
    gen_statem:call(PID,{accepted,Company}).
fire(PID)->
    gen_statem:call(PID,fired).
promote(PID,Title)->
    gen_statem:call(PID,{promoted,Title}).

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
    {next_state,sitting_home,Data,[{reply,From,{rejected,Company}}]};
interviewing({call,From},{accepted,Company},Data=#data{jobCount=J,positions=P})->
    {next_state,working,Data#data{current=Company,jobCount=J+1,positions=[{"fresh_hire",Company}|P]},[{reply,From,{accepted,Company}}]};
interviewing(EventType,Event,Data)->
    handle(EventType,Event,Data).

working({call,From},{promoted,Title},Data=#data{positions=L,current=C})->
    {keep_state,Data#data{positions=[{Title,C}|L]},{reply,From,{promoted_by,C,Title}}};
working({call,From},fired,Data=#data{positions=L,current=C})->
    {next_state,sitting_home,Data#data{current="None"},{reply,From,{fired,C}}};
working(EventType,Event,Data)->
    handle(EventType,Event,Data).

handle({call,From},state,Data)->
    {keep_state,Data,[{reply,From,Data}]};
handle({call,From},State,Data)->
    {keep_state,Data,[{reply,From,got_nothing_for_you}]};
handle(_,State,Data)->
    {keep_state,Data}.




