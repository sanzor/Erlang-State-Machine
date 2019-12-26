-module(mgr).
-import(h1,[init/1]).
-export([start/0,addh/2,add/3]).

start()->
    Manager=?MODULE,
    {ok,MPid}=gen_event:start_link({local,Manager}),
    MPid.

addh(HType,MPid)->
    gen_event:add_handler(MPid,HType,[]).
   
add(MPid,K,V)->
    gen_event:notify(MPid,{add,{K,V}}).
remove(MPid,K,V)->
    gen_event:notify(MPid,{remove,K}).

state(Pid,HType)->
    gen_event:call(Pid,HType,state).