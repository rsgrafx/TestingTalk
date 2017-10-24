## Testing Elixir



1. The name of this talk is Elixir Testing, I know that the name is very broad, Testing as a whole - I know that I won’t be able to scratch the surface on what ExUnit is capable of doing but for the most part I the goal of the talk is get you acquainted with the core capabilities.

#### About Me

1. I’ve been developing apps for about 8 years now.  5 1/2 years of that has been Ruby on Rails applications. The rest has been solely building elixir applications. ( Phoenix applications ).

Like a lot of developers testing is not something I think right off the back when I approach building a new application or learning a new language.  But here are some reasons why I feel its important.

* Avoiding regression. - Breaking changes.
2. Ease of Refactoring.
3. Building Confidence in your code and as a developer.	


> Focusing on the point of  building confidence in your code.  

While your trying to get to a rough draft on a project your working on if you have tests you will find your self feeling good about improving any code without breaking your mvp.  Iterating to something more elegant. I helps quell that fear of iterating because you know if you break a test, you can back out and re-examine your change.  Or if your like me you just simply say.. who cares how the code looks its tested.


What is ExUnit
===

1. As stated in the docs - It is Elixir’s Unit Testing framework - but what about Acceptance , Integration tests ? We’ll get to that.

ExUnit includes everything we need to thoroughly test our code.

2. Unit Tests, are focused on a single portion of the system that can be verified on its own.


So Lets look at basic setup:

> Script Example:

Here you have a basic Elixir test script [example](https://github.com/rsgrafx/TestingTalk/blob/7b5c89fc1ac4cb078bdcf961d165d7a42a286bb5/hello-world-scripts/hello_world_test.exs#L20)

`ExUnit.start()` - starts the process

`ExUnit.configure()` - loads in configuration.
	
#### The Basic DSL.
	
	
	defmodule MyTestName do 
		use ExUnit.Case
		test “name of test”  do 
			logic and assertions
		end
	end

scripts like this are called via `elixirc filename`

### General idea of What ExUnit does.

What happens when your test begin to run - When `ExUnit.start()` is triggered.

the will read in the file or files _test.exs and start create an individual
struct - `ExUnit.TestModule` and populate the tests attribute on that module with an `ExUnit.Test` struct.

[Starting Point](https://github.com/rsgrafx/TestingTalk/blob/995200edf1414fab5418dd2c437cc68f0412b760/ex_unit/lib/ex_unit.ex#L133)

### ExUnit.Test = Test Case 

A TestCases are sets of steps which are performed on a system to verify the expected output.

### ExUnit.TestModule = Test Scenario

This consists of a detailed Test procedure.  Made up of TestCases.

<!--Now getting into the full grit of whats heppening with those processes can be done in another talk.  I think the goal is to mainly give you a fair idea
-->

How are those `ExUnit.Test` structs created at runtime - for that we have to take a look at the `test` macro.

### Macros - ExUnit.Case

• [test](https://github.com/rsgrafx/TestingTalk/blob/995200edf1414fab5418dd2c437cc68f0412b760/ex_unit/lib/ex_unit/case.ex#L266)

• [describe](https://github.com/rsgrafx/TestingTalk/blob/995200edf1414fab5418dd2c437cc68f0412b760/ex_unit/lib/ex_unit/case.ex#L372)

### Context - ExUnit.Callbacks

* Lets see how Context plays in all this.

[ExUnit CallBack Tests](https://github.com/rsgrafx/TestingTalk/blob/fff8f85838c628829308beeffbadd2db9e543343/ex_unit/test/ex_unit/callbacks_test.exs#L39)

* The Type of Tags - and context

These macros help ExUnit mimic conditions under which functionality is called to test for desired result.

[How ExUnit registers a test to be run](https://github.com/rsgrafx/TestingTalk/blob/fff8f85838c628829308beeffbadd2db9e543343/ex_unit/lib/ex_unit/case.ex#L436)

setup

setup_all

### Assertions

[assert](https://elixirschool.com/en/lessons/basics/testing/#assert)

[refute](https://elixirschool.com/en/lessons/basics/testing/#refute)

* run test once again.

### Mix Applications

* But this not how majority of elixir apps are setup - they are all some form of mix application.

`mix help test`

Mix Applications - but before we talk about mix apps and testing - lets Segway a bit and talk about Boundaries.

How do we define Boundaries? * Interaction point - Ask for feedback.

What we have access in Elixir by virtue Erlang is the ability to build a lot of isolated functional cores that communicate with each other.  We encapsulate this functionality in processes.  How do we ensure these processes we create are behaving correctly.  How do we test them.


Testing OTP examples




Testing Phoenix



You may be new to a language - but you may not be new to a domain. Knowing how to write tests should be one of the initial things you learn while gettin your mvp off the ground.

One of the main goals of testing your code is gaining assurances.  Now me coming from the the ruby world where things can get mutated on the fly. Assurance was key to my sanity.   In Elixir I found that I did not have that problem not to say that you can’t get things wrong but its much easier to follow how your passing the data along to see where you the issue lies.