-module(h1).
-behaviour(gen_event).
-record(state,{
    players
}).
-export([init/1]).


init([])->
    {ok,#state{names=maps:new()}}.

handle_event({add,{K,V}},State)->
    case maps:is_key(K,State#state.names) of
        true -> {ok,State};
        false-> 
            Team=maps:put(K,V,State#state.names),
            {ok,State=#state{names=Team}}
    end.
handle_event({remove,K},State#state{players=Players})->
    case maps:is_key(K,Players) of
        true -> 
            NewPlayers=maps:remove(K,Players),
            {ok,State#state{players=NewPlayers}};
        false->{ok,State}
    end.

handle_call(state,State)->
    {ok,State,State}.


