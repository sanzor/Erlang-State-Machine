-module(h0).

-behaviour(gen_event).
-record(state,{
    players,
    test=0,
    pid
}).




init(ToPid)->
    {ok,#state{players=maps:new(),pid=ToPid}}.
    
handle_event({add,{K,V}},State)->
    case maps:is_key(K,State#state.players) of
        true -> {ok,State};
        false-> 
            Team=maps:put(K,V,State#state.players),
            {ok,State#state{players=Team}}
    end;
handle_event({remove,K},State=#state{players=Players})->
    case maps:is_key(K,Players) of
        true -> 
            NewPlayers=maps:remove(K,Players),
            {ok,State#state{players=NewPlayers}};
        false->{ok,State}
    end.
handle_event(Event,State=#state{pid=Pid})->
    Pid !Event.

handle_call(state,State)->
    {ok,State,State}.