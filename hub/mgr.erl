-module(mgr).
%-import(h1,[init/1]).
-import(hfeed,[init/1]).
-export([start/0,addh/3,add/3,join/3]).

start()->
    Manager=?MODULE,
    {ok,MPid}=gen_event:start_link({local,Manager}),
    MPid.

addh(HType,MPid,Args)->
    gen_event:add_handler(MPid,HType,[Args]).
   
add(MPid,K,V)->
    gen_event:notify(MPid,{add,{K,V}}).
remove(MPid,K,V)->
    gen_event:notify(MPid,{remove,K}).

join(MPid,HandlerType,ToPid)->
    HandlerId={HandlerType,make_ref()},
    gen_event:add_handler(MPid,HandlerType,ToPid),
    HandlerId.

remove(Mpid,HandlerId)->
    gen_event:remove_handler(Mpid,HandlerId,leave_feed).

state(Pid,HType)->
    gen_event:call(Pid,HType,state).