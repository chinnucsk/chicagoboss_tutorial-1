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
    {ok, SavedGreeting} = NewGreeting:save(),
    {redirect, [{action, "list"}]}.

goodbye('POST', []) ->
    boss_db:delete(Req:post_param("greeting_id")),
    {redirect, [{action, "list"}]}.