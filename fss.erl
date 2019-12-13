-module(fss).
-export([init/1,callback_mode/0,code_change/4,terminate/3]).
-behaviour(gen_statem).
-record(state,{
    count=0,
    monitor
}).
callback_mode()->state_functions.

init([])->
    {next_state,on,#state{count=0}}.

terminate(_Reason,State,Data)->
    void.

code_change(_Vs,State,Data,Extra)->
    {ok,State,Data}.


on({call,From},State)->

