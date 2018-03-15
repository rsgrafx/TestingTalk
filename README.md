# Testing Elixir


The name of this talk is Elixir Testing, I know that the title sounds grand, Testing as a whole is extremely broad - I know that I won’t be able to scratch the surface on what ExUnit is capable of doing but for the most part the goal of the talk is get you generally acquainted with the library's capabilities and share some tips from the frontlines. 

> Disclaimer This not a Talk on TDD but I may draw on some concepts accidentally.

### About Me

Like a lot of developers testing was not something I would think to do right off the bat when I approach building a new application or learning a new language.  But after much painful learning here are some reasons why I feel its important think of testing upfront.

> #### 1. Avoiding regression.

Breaking changes happen. You need something to keep you in check.

> #### 2. Ease of Refactoring.

If you do decide to change some already working code to something more elegant.  Your tests are your guide to success.

> #### 3. Building Confidence in your code and as a developer.

While your trying to get to a rough draft on a project if you have tests you will find your self feeling good about improving any code without breaking your mvp.  You will feel confident about stopping points. Who cares how the code looks its tested.


## What is ExUnit

As stated in the docs - It is Elixir’s <b>Unit</b> Testing framework - but what about Acceptance , Integration tests ? We’ll get to that.

ExUnit includes everything we need to thoroughly test our code.

### Let's Dive in.

> #### Test Scripts

These are the mininum requirements to get ExUnit up and running.  

> In your script you need:
You create a file it must end with _test.exs 

`ExUnit.start()` - starts the process

`ExUnit.configure()` - Loads in configuration.

Defining your test scenario usually follows this pattern.

```	
defmodule MyTestModuleTest do 
	use ExUnit.Case
	test “name of test”  do 
		logic and assertions
	end
end
```

> ### Elixir Script [example](https://github.com/rsgrafx/TestingTalk/blob/7b5c89fc1ac4cb078bdcf961d165d7a42a286bb5/hello-world-scripts/hello_world_test.exs#L20):
	
you can run this file via `$> elixir path/to/filename_test.exs`

### General idea of What ExUnit does.

When `ExUnit.start()` is called.

* The main ExUnit Process is started 

* The process will read in the file or files _test.exs and start create an individual struct - `ExUnit.TestModule` for each testmodule you have defined and populate the tests attribute on that module with an `ExUnit.Test` struct for eac test defined in your module.

* `ExUnit.Test` ExUnit will convert the struct into an function. What this function returns - specifies whether a test is a passing test or failing test.

[ExUnit.start Application](https://github.com/rsgrafx/TestingTalk/blob/995200edf1414fab5418dd2c437cc68f0412b760/ex_unit/lib/ex_unit.ex#L133)

In the world of Testing there is a lot of terminology. Generally speaking.

### ExUnit.TestModule = Test Scenario

A Test Scenario is any functionality that can be tested.  This consists of a detailed Test procedure.  Made up of TestCases.	

### ExUnit.Test = Test Case 

A TestCases are sets of steps which are performed on a system to verify the expected output.

<!--
Now getting into the full grit of whats heppening with those processes fuel for another talk.  I think the goal is to mainly give you a fair idea what is going on.
-->

How are those `ExUnit.Test` structs created at runtime - for that we have to take a look at the `test` macro.

# The DSL

<!-- 
Made up of several macros that help you structure your test suite, test cases in way that closely mirrors how you can read in a spec doc. 
-->

### Macros - ExUnit.Case

Lets look at the ExUnit definitions for commonly used macros

#### * [test](https://github.com/rsgrafx/TestingTalk/blob/995200edf1414fab5418dd2c437cc68f0412b760/ex_unit/lib/ex_unit/case.ex#L266)

>  [register_test a function called internally](https://github.com/rsgrafx/TestingTalk/blob/fff8f85838c628829308beeffbadd2db9e543343/ex_unit/lib/ex_unit/case.ex#L436)

The gist of what's happening is the test macro defines a function on the module the macro was used.

The registering of that test - this function does a couple things it
checks that a function by that name was not already implemented and builds the environment in which that function should run.

```
  # Place this before the last end in your TestModule 
  # tests are converted to functions.
  
  IO.inspect Module.definitions_in(HelloWorldTest, :def)
```
#### * [describe](https://github.com/rsgrafx/TestingTalk/blob/995200edf1414fab5418dd2c437cc68f0412b760/ex_unit/lib/ex_unit/case.ex#L372)

Every describe block receives a name which is used as prefix for upcoming tests. Inside a block, ExUnit.Callbacks.setup/1 may be invoked and it will define a setup callback to run only for the current block. The describe name is also added as a tag, allowing developers to run tests for specific blocks.

### Context & ExUnit.Callbacks

> #### The world surrounding your Test.

[Tagged test Example](https://github.com/rsgrafx/TestingTalk/blob/7b5c89fc1ac4cb078bdcf961d165d7a42a286bb5/module_tags/example_code_loading_test.exs)

Context data helps each test run in specific scope.  We can use tags or callbacks to help get data required to test how our functionality works when the variables have changed.

`@tag` attributes are placed just above the implementation the `test` macro.
They are used to pass data from the test to the callback.

`@moduletag` attribute is placed at the top of the file within your TestModule.  They are used to define some arbitrary data that you would want already set for all tests or a `describe` block.

`setup` callback - is run in the same process as the test itself.

`setup_all` callback - is run in a seperate process per module.

In order to understand callbacks it might be good to understand what's happening.  Here is a run down of the life-cycle of the test process:

* the test process is spawned
* it runs setup/2 callbacks
* it runs the test itself
* it stops all supervised processes
* the test process exits with reason :shutdown
* on_exit/2 callbacks are executed in a separate process

These macros help ExUnit mimic conditions under which functionality is called to test for desired result.

> #### [ExUnit Context Tests](https://github.com/rsgrafx/TestingTalk/blob/fff8f85838c628829308beeffbadd2db9e543343/ex_unit/test/ex_unit/callbacks_test.exs#L39) * Note that ExUnit itself is tested with ExUnit.

### Assertions

[Great examples and Introduction](https://elixirschool.com/en/lessons/basics/testing/)

[assert](https://elixirschool.com/en/lessons/basics/testing/#assert)

[refute](https://elixirschool.com/en/lessons/basics/testing/#refute)

* run test once again. 

> This not how majority of elixir apps are setup - they are all some form of mix application.

## Mix Applications

`mix` is Elixir's go to build tool for app management.  It comes pre built with testing functionality.  Its not tied specifically to ExUnit.  If there is any other testing framework you can simply drop it in and write your tests in it.

When you create an new app - A `test` folder already setup with a `test_helper.exs` file in it.  You can put some logic in this file but mostly it's there for mission critical directives such as

`ExUnit.start()` or `Application.ensure_all_started(:your_fav_testing_helper_app)`

In a new mix app. Everything is already preconfigured.

`mix test`

### What's possible via `mix test` interface quick list

`mix help test`

[Quick write up with mix testing tips](https://medium.com/blackode/elixir-testing-running-only-specific-tests-746cfc24d904)

`mix test`

`mix test path_to_your_file.exs:10`

`mix test path_to_your_file.exs`


```
@tag runnable: true
test ....

mix test --include runnable:true
```

`mix test --only describe:"Block A"`

`mix test --only describe:"PMap"`

```
# mix.exs

  ...
  
  defp deps do
    [{:test_package, only: [:dev, :test]}]
  end

  defp aliases do
    [
      test: ["ecto.drop", "ecto.create", "ecto.migrate", "test"],
      foobar: ["run -e 'IO.puts(\"One\")'", "run -e 'Mix.Task.reenable(:run)'"]
    ]
  end

```


In summary Mix is a elixir's build has a lot of niceties that help you manage your tests.  I encourage you to read up more - just look at the docs.

## Lets Segway a bit and talk about Boundaries.

How do we define Boundaries? - feedback.

##### Update March/2018 - I recently watched a talk from Empex LA by @andrewhao Phoenix Contexts - Context Mapping.

[Slides](http://www.g9labs.com/beautiful-systems-with-phoenix-contexts-talk/#35)

[Talk](https://www.youtube.com/watch?v=oJghZB9sSuU)


I would encourage watching it.  From my experience developing phoenix 1.3 apps I can attest the benefits of Contexts and how they have influenced my testing.

Doing Context Mapping generally leads to the creation of better tests.  Context mapping helps can identify the system boundaries, which intern help you create better API’s for integration testing. Creating other forms of tests benefit from this practice as well.


## Testing and GenServers

What we have access in Elixir by virtue Erlang is the ability to build a lot of isolated functional cores that communicate with each other.  We encapsulate this functionality in processes.  How do we ensure these processes we create are behaving correctly.  How do we test them.

> #### Here is an example of testing a module with GenServer behaviour.

[GenServer Test](https://github.com/rsgrafx/TestingTalk/blob/master/genserver_testing/test/lib/password_lock_test.exs)

[Module with GenServer Behaviour](https://github.com/rsgrafx/TestingTalk/blob/master/genserver_testing/lib/genserver_testing.ex)

## Testing in Phoenix

Disclaimer: Testing in Phoenix a topic that warrants its own talk.  This is just an overview.


> #### Guess what - Phoenix is a just another mix application.  Phoenix includes modules that make use of `ExUnit.CaseTemplate` to group functionality for testing things built from different parts of the framework.
---

> #### ExUnit.CaseTemplate

This module allows a developer to define a test case template to be used throughout their tests. This is useful when there are a set of functions that should be shared between tests or a set of setup callbacks.

Because of the nature of Phoenix and the different moving parts - Contexts, Controllers, and Views. Phoenix makes use of this module to section off test groups with shared functionality.

[ConnCase Example](https://github.com/rsgrafx/TestingTalk/blob/master/redirecting_app/test/support/conn_case.ex)

For Example if your using fixtures. Your tests for your Phoenix Controllers dont need to include those functions.  The test modules you define that test your Phoenix Contexts probably do.

[Great Fixture Ecto writeup](http://blog.danielberkompas.com/elixir/2015/07/16/fixtures-for-ecto.html)

[Example of a Context Case pulled from an app I worked on.](https://github.com/rsgrafx/TestingTalk/blob/master/one-offs/example_context_case.ex)

--

> #### Integration Testing and Phoenix.
> Phoenix already makes it easy to write tests for your controllers.  Hound makes writing Integration tests easy by runnning phoenix that run in a headless browser. 

 You can put this in your mix.exs 
` {:hound, "~> 1.0", only: [:dev, :test]}`
 
 Ensure that the application starts when by putting 
 `Application.ensure_all_started(:hound)` in  test_helper.exs

[Excellent Hound Tutorial](https://semaphoreci.com/community/tutorials/end-to-end-testing-in-elixir-with-hound) 

##### Built-in Test helpers

> Readup on Phoenix.ChannelTest

> Readup on Phoenix.ConnTest

##### Ecto
[Elixir LDN - Ecto Shared Process explanation](https://youtu.be/jhZwQ1LTdUI?t=15m1s) Tagged Youtube Video at mark where speaker begins explaining shared processes. Issues with Ecto - are solely when you dont set things up correctly.

An additional explanation on the same topic of Shared processes. [Making Sense of Ecto 2 SQL.Sandbox and Connection Ownership Modes](https://medium.com/@qertoip/making-sense-of-ecto-2-sql-sandbox-and-connection-ownership-modes-b45c5337c6b7)

```
setup do
   :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
end

```

### Testing Third Party API's 

> Honorable Mentions

##### Bypass Hex Package

> [Bypass](https://github.com/pspdfkit-labs/bypass) provides a quick way to create a custom plug that can be put in place instead of an actual HTTP server to return prebaked responses to client requests. This is most useful in tests, when you want to create a mock HTTP server and test how your HTTP client handles different types of responses from the server.

> It elimenates the need for Adapter Pattern / Testing - the need to define condtionals in your code based on the environment your running in.

[Example Bypass Tests](https://github.com/rsgrafx/TestingTalk/blob/master/bypass_app/test/integration/client_test.exs)

[ExVCR](https://github.com/parroty/exvcr)

### Failed to Mention

* Doc Tests - pretty straight forward. 

* Static Types with regards to Testing.


[Testing Mix Tasks](https://jc00ke.com/2017/04/05/testing-elixir-mix-tasks/)

### TDD and Red Green Refactor

Hex Package: Mix Test Watch

Setup:
	[Mix Test Watch](https://github.com/rsgrafx/TestingTalk/blob/a9ecc63fc123fdc363f2a39f49fbe11e3a92e789/genserver_testing/mix.exs#L22)
	
`mix test.watch`

### Additional Reads

[semaphoreci ExUnit intro](https://semaphoreci.com/community/tutorials/introduction-to-testing-elixir-applications-with-exunit)

[semaphoreci testing streams](https://semaphoreci.com/community/tutorials/test-driving-a-stream-powered-elixir-library)


> #### Conclusion

You may be new to a language - but you may not be new to a domain. Knowing how to write tests should be one of the initial things you learn while gettin your mvp off the ground.

One of the main goals of testing your code is gaining assurances.  Now me coming from the the ruby world where things can get mutated on the fly. Assurance was key to my sanity.   In Elixir I found that I did not have that problem not to say that you can’t get things wrong but its much easier to follow how your passing the data along to see where you the issue lies.

### To Be Cont'd

`#Always Read the Docs`