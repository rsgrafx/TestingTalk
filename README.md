# Testing Elixir


The name of this talk is Elixir Testing, I know that the title sounds grand, Testing as a whole is extremely broad - I know that I won’t be able to scratch the surface on what ExUnit is capable of doing but for the most part the goal of the talk is get you generally acquainted with the library's capabilities.

### About Me

Like a lot of developers testing was not something I think to do right off the bat when I approach building a new application or learning a new language.  But after much painful learning here are some reasons why I feel its important think of testing upfront

> #### 1. Avoiding regression.
	* Breaking changes you need something to keep you in check.

> #### 2. Ease of Refactoring.
	* If you do decide to change some already working code to something elegant.  Your tests are your guide to success.

> #### 3. Building Confidence in your code and as a developer.	
> On the point of building confidence in your code.
	* While your trying to get to a rough draft on a project your working on if you have tests you will find your self feeling good about improving any code without breaking your mvp.  Iterating to something more elegant. I helps quell that fear of iterating because you know if you break a test, you can back out and re-examine your change.  Or if your like me you just simply say.. who cares how the code looks its tested.


## What is ExUnit

1. As stated in the docs - It is Elixir’s <b>Unit</b> Testing framework - but what about Acceptance , Integration tests ? We’ll get to that.

ExUnit includes everything we need to thoroughly test our code.

### Let's Dive in.

> #### Test Scripts

These are the mininum requirements to get ExUnit up and running.  

> In your script you need:
You create a file it must have _test.exs 

`ExUnit.start()` - starts the process

`ExUnit.configure()` - Loads in configuration - but does not have the niceties of mix app.

Define your Test Scenario 
```	
defmodule MyTestName do 
	use ExUnit.Case
	test “name of test”  do 
		logic and assertions
	end
end
```

> ### Elixir Script Example:

##### `$> elixir path_to/script_name.exs`

Here you have a basic Elixir test script [example](https://github.com/rsgrafx/TestingTalk/blob/7b5c89fc1ac4cb078bdcf961d165d7a42a286bb5/hello-world-scripts/hello_world_test.exs#L20)
	
you can run this file via `$> elixirc filename_test.exs`

### General idea of What ExUnit does.

What happens when your test begin to run - When `ExUnit.start()` is triggered.

[Starting Point](https://github.com/rsgrafx/TestingTalk/blob/995200edf1414fab5418dd2c437cc68f0412b760/ex_unit/lib/ex_unit.ex#L133)

* The main ExUnit Process is started 

* The process will read in the file or files _test.exs and start create an individual struct - `ExUnit.TestModule` for each testmodule you have defined and populate the tests attribute on that module with an `ExUnit.Test` struct.

* Each `ExUnit.Test` struct will contain data that will allow ExUnit to convert that data into an executable function. What this function returns - specifies whether a test is a passing test or failing test.

### ExUnit.TestModule = Test Scenario

This consists of a detailed Test procedure.  Made up of TestCases.

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

* [test macro](https://github.com/rsgrafx/TestingTalk/blob/995200edf1414fab5418dd2c437cc68f0412b760/ex_unit/lib/ex_unit/case.ex#L266) |  [registers a test internally](https://github.com/rsgrafx/TestingTalk/blob/fff8f85838c628829308beeffbadd2db9e543343/ex_unit/lib/ex_unit/case.ex#L436)

The gist of what's happening is the test macro defines a function on the module the macro was used.

The registering of that test - this function does a couple things but mainly
checks a function by that name was already implemented and builds the environment in which that function should run.

```
  # Place this before the last end in your TestModule 
  # tests are converted to functions.
  
  IO.inspect Module.definitions_in(HelloWorldTest, :def)
```
* [describe](https://github.com/rsgrafx/TestingTalk/blob/995200edf1414fab5418dd2c437cc68f0412b760/ex_unit/lib/ex_unit/case.ex#L372)

### Context & ExUnit.Callbacks

> #### The world surrounding your Test.

Context is a decription of the data being passed around that helps each test run in specific scope.  We can use tags or callbacks to help get specific data required to test how our functionality works in different environments.

`@tag` are placed just above the defining the `test` directive.
They are used to pass data from the test to the callback.

`@moduletag` placed at the top of the file within your TestModule.  They are used to define some arbitrary data that you would want already set for all tests or a `describe` block.

In order to understand callbacks it might be good to understand what's happening.  Here is a run down of the life-cycle of the test process:

* the test process is spawned
* it runs setup/2 callbacks
* it runs the test itself
* it stops all supervised processes
* the test process exits with reason :shutdown
* on_exit/2 callbacks are executed in a separate process

These macros help ExUnit mimic conditions under which functionality is called to test for desired result.

> #### [ExUnit Context Tests](https://github.com/rsgrafx/TestingTalk/blob/fff8f85838c628829308beeffbadd2db9e543343/ex_unit/test/ex_unit/callbacks_test.exs#L39)


> #### [How ExUnit registers a test internally](https://github.com/rsgrafx/TestingTalk/blob/fff8f85838c628829308beeffbadd2db9e543343/ex_unit/lib/ex_unit/case.ex#L436)

`setup` - is run in the same process as the test itself.

`setup_all` - is run in a seperate process per module.

[Example using Tag and Setup](https://github.com/rsgrafx/TestingTalk/blob/fff8f85838c628829308beeffbadd2db9e543343/module_tags/example_code_loading_test.exs#L5)

### Assertions

[Great examples and Introduction](https://elixirschool.com/en/lessons/basics/testing/)

[assert](https://elixirschool.com/en/lessons/basics/testing/#assert)

[refute](https://elixirschool.com/en/lessons/basics/testing/#refute)

* run test once again. 

> This not how majority of elixir apps are setup - they are all some form of mix application.

## Mix Applications

When you create an new app - A `test` folder already setup with a `test_helper.exs` file in it.  You can put some logic in this file but mostly it's there for mission critical directives such as 

`ExUnit.start()` or `Application.ensure_all_started(:your_fav_testing_helper_app)`

`mix` is Elixir's go to build tool for app management.  It comes pre built with testing functionality to see that.  Its not tied specifically to ExUnit.  If there is any other testing framework you can simply drop it in and write your tests in it.

`$> mix help test`

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

## Testing and GenServers

Here is an example of testing a Module that uses GenServer behaviour.

What we have access in Elixir by virtue Erlang is the ability to build a lot of isolated functional cores that communicate with each other.  We encapsulate this functionality in processes.  How do we ensure these processes we create are behaving correctly.  How do we test them.

[GenServer Test](https://github.com/rsgrafx/TestingTalk/blob/master/genserver_testing/test/lib/password_lock_test.exs)

[Module with GenServer Behaviour](https://github.com/rsgrafx/TestingTalk/blob/master/genserver_testing/lib/genserver_testing.ex)

## Testing in Phoenix

#### Guess what - Phoenix is a just another mix application.
	
> #### ExUnit.CaseTemplate

This module allows a developer to define a test case template to be used throughout their tests. This is useful when there are a set of functions that should be shared between tests or a set of setup callbacks.

Because of the nature of Phoenix and the different moving parts - Contexts, Controllers, and Views. Phoenix makes use of this module to section off test groups with shared functionality.

For Example using fixtures. Tests for your Phoenix Controllers dont need to include those functions.  The test modules you define that test your Phoenix Contexts probably do.

Phoenix already makes it easy to write tests for your controllers.  Integeration in phoenix that run in a headless browser. 

 You can put this in your mix.exs 
` {:hound, "~> 1.0", only: [:dev, :test]}`
 
 Ensure that the application starts when by putting 
 `Application.ensure_all_started(:hound)` in  test_helper.exs

[Excellent Hound Tutorial](https://semaphoreci.com/community/tutorials/end-to-end-testing-in-elixir-with-hound) 

##### Built-in Test helpers

> Readup on Phoenix.ChannelTest

> Readup on Phoenix.ConnTest

##### Ecto
[Elixir LDN - Ecto Shared Process explanation](https://youtu.be/jhZwQ1LTdUI?t=15m1s)

Issues with Ecto - are solely when you dont set things up correctly.

[Blog Post](https://medium.com/@qertoip/making-sense-of-ecto-2-sql-sandbox-and-connection-ownership-modes-b45c5337c6b7)

```
setup do
   :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
end

```

### Testing Third Party API's 

Honorable Mentions

[Bypass](https://github.com/pspdfkit-labs/bypass)

[ExVCR](https://github.com/parroty/exvcr)

### Failed to Mention

* DocTests

* Static Types and Testing

> #### Conclusion

You may be new to a language - but you may not be new to a domain. Knowing how to write tests should be one of the initial things you learn while gettin your mvp off the ground.

One of the main goals of testing your code is gaining assurances.  Now me coming from the the ruby world where things can get mutated on the fly. Assurance was key to my sanity.   In Elixir I found that I did not have that problem not to say that you can’t get things wrong but its much easier to follow how your passing the data along to see where you the issue lies.

[Testing Mix Tasks](https://jc00ke.com/2017/04/05/testing-elixir-mix-tasks/)

### TDD and Red Green Refactor

Hex Package: Mix Test Watch

Setup:
	[Mix Test Watch](https://github.com/rsgrafx/TestingTalk/blob/a9ecc63fc123fdc363f2a39f49fbe11e3a92e789/genserver_testing/mix.exs#L22)
	
`mix test.watch`

### Bibliography - 

[semaphoreci exunit intro](https://semaphoreci.com/community/tutorials/introduction-to-testing-elixir-applications-with-exunit)

[semaphoreci testing streams](https://semaphoreci.com/community/tutorials/test-driving-a-stream-powered-elixir-library)

### To Be Cont'd

