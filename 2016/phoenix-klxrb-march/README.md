# Phonix Framework Demo

## Start the project

```
$ mix phoenix.new my_app
* creating my_app/config/config.exs
* creating my_app/config/dev.exs
* creating my_app/config/prod.exs
* creating my_app/config/prod.secret.exs
* creating my_app/config/test.exs
* creating my_app/lib/my_app.ex
* creating my_app/lib/my_app/endpoint.ex
* creating my_app/test/views/error_view_test.exs
* creating my_app/test/support/conn_case.ex
* creating my_app/test/support/channel_case.ex
* creating my_app/test/test_helper.exs
* creating my_app/web/channels/user_socket.ex
* creating my_app/web/router.ex
* creating my_app/web/views/error_view.ex
* creating my_app/web/web.ex
* creating my_app/mix.exs
* creating my_app/README.md
* creating my_app/web/gettext.ex
* creating my_app/priv/gettext/errors.pot
* creating my_app/priv/gettext/en/LC_MESSAGES/errors.po
* creating my_app/web/views/error_helpers.ex
* creating my_app/lib/my_app/repo.ex
* creating my_app/test/support/model_case.ex
* creating my_app/priv/repo/seeds.exs
* creating my_app/.gitignore
* creating my_app/brunch-config.js
* creating my_app/package.json
* creating my_app/web/static/css/app.css
* creating my_app/web/static/js/app.js
* creating my_app/web/static/js/socket.js
* creating my_app/web/static/assets/robots.txt
* creating my_app/web/static/assets/images/phoenix.png
* creating my_app/web/static/assets/favicon.ico
* creating my_app/test/controllers/page_controller_test.exs
* creating my_app/test/views/layout_view_test.exs
* creating my_app/test/views/page_view_test.exs
* creating my_app/web/controllers/page_controller.ex
* creating my_app/web/templates/layout/app.html.eex
* creating my_app/web/templates/page/index.html.eex
* creating my_app/web/views/layout_view.ex
* creating my_app/web/views/page_view.ex

Fetch and install dependencies? [Yn] y
* running mix deps.get
* running npm install && node node_modules/brunch/bin/brunch build

We are all set! Run your Phoenix application:

    $ cd my_app
    $ mix phoenix.server

You can also run your app inside IEx (Interactive Elixir) as:

    $ iex -S mix phoenix.server

Before moving on, configure your database in config/dev.exs and run:

    $ mix ecto.create
$ cd my_app
$ mix ecto.create
The database for MyApp.Repo has been created.
```


## Create Post scaffolding

```
$ cd my_app
$ mix phoenix.gen.html Post posts title:string, body:string
* creating web/controllers/post_controller.ex
* creating web/templates/post/edit.html.eex
* creating web/templates/post/form.html.eex
* creating web/templates/post/index.html.eex
* creating web/templates/post/new.html.eex
* creating web/templates/post/show.html.eex
* creating web/views/post_view.ex
* creating test/controllers/post_controller_test.exs
* creating priv/repo/migrations/20160229151801_create_post.exs
* creating web/models/post.ex
* creating test/models/post_test.exs

Add the resource to your browser scope in web/router.ex:

    resources "/posts", PostController

Remember to update your repository by running migrations:

    $ mix ecto.migrate
```

Add `resources "/posts", PostController` to `web/router.ex` and run the migration:

```
$ mix ecto.migrate

23:22:35.058 [info]  == Running MyApp.Repo.Migrations.CreatePost.change/0 forward

23:22:35.059 [info]  create table posts

23:22:35.064 [info]  == Migrated in 0.0s
```

Let's make sure the test are passing:

```
mix test
................

Finished in 0.3 seconds (0.2s on load, 0.08s on tests)
16 tests, 0 failures

Randomized with seed 12674
```

And let's see if we can see the web application:

```
mix phoenix.server
[info] Running MyApp.Endpoint with Cowboy using http on port 4000
29 Feb 23:26:00 - info: compiled 5 files into 2 files, copied 3 in 610ms
```

Head to browser http://localhost:4000/posts

Spend some of your time to look at model and controller that phoenix is created for you
