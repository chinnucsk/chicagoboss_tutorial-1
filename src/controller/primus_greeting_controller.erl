-module(primus_greeting_controller, [Req]).
-compile(export_all).

index('GET', []) ->
    {ok, [{greeting, "Hello World!"}]}.


hello('GET', []) ->
     {ok, [{greeting, "Hello, world!"}]}. 

list('GET', []) ->
    Greetings = boss_db:find(greeting, []),
    {ok, [{greetings, Greetings}]}.

create('GET', []) ->
    ok;

create('POST', []) ->
    GreetingText = Req:post_param("greeting_text"),
    Author = Req:post_param("author"),
    NewGreeting = greeting:new(id, GreetingText, Author),
    case NewGreeting:save() of
    {ok, SavedGreeting} ->
        {redirect, [{action, "list"}]};
    {error, ErrorList} ->
        {ok, [{errors, ErrorList}, {new_msg, NewGreeting}]}
    end.
    

goodbye('POST', []) ->
    boss_db:delete(Req:post_param("greeting_id")),
    {redirect, [{action, "list"}]}.

pull('GET', [LastTimestamp]) ->
    {ok, Timestamp, Greetings} = boss_mq:pull("new-greetings", 
        list_to_integer(LastTimestamp)),
    {json, [{timestamp, Timestamp}, {greetings, Greetings}]}.

live('GET', []) ->
    Greetings = boss_db:find(greeting, []),
    Timestamp = boss_mq:now("new-greetings"),
    {ok, [{greetings, Greetings}, {timestamp, Timestamp}]}.
