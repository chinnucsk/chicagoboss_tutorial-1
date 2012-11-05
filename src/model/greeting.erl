-module(greeting, [Id, GreetingText, Author]).
-compile(export_all).

validation_tests() ->
	[{fun() -> length(GreetingText) > 0 end,
		"Greeting Must be Non-Empty"},
	  {fun() -> length(GreetingText) =< 140 end,
	  	"Gretting Text must be tweetable"
	}].

before_create() ->
	error_logger:info_msg("GreetingText: ~p", [GreetingText]), 
	ModifiedRecord = set(greeting_text, re:replace(GreetingText, "masticate", "chew", [{return, list}])),
	error_logger:info_msg("ModifiedRecord: ~p", [ModifiedRecord]),
	{ok, ModifiedRecord}.

after_create() ->
    boss_mq:push("new-greetings", THIS).
