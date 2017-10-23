Testing Elixir
----


1. The name of this talk is Elixir Testing, I know that the name is very broad, Testing as a whole - I know that I won’t be able to scratch the surface on what ExUnit is capable of doing but for the most part I the goal of the talk is get you acquainted with the core capabilities.

About Me
===

1. Who am I.  My name is Orion, I’ve been developing apps for about 8 years now.  5 1/2 years of that has been Ruby on Rails applications. The rest has been solely building elixir applications. ( Phoenix applications ) .

Like a lot of developers testing is not something I think right off the back when I approach building a new application or learning a new language.  But here are some reasons why I feel its important.

	1. Avoiding regression.
	2. Ease of Refactoring.
	3. Building Confidence.
	
*Focusing on the point of  building confidence in your code.  

While your trying to get to a rough draft on a project your working on if you have tests you will find your self feeling good about improving any code without breaking your mvp.  Iterating to something more elegant. I helps quell that fear of iterating because you know if you break a test, you can back out and re-examine your change.  Or if your like me you just simply say.. who cares how the code looks its tested.


What is ExUnit
===

1. As stated in the docs - It is Elixir’s Unit Testing framework - but what about Acceptance , Integration tests ? We’ll get to that.

ExUnit includes everything we need to thoroughly test our code.

2. Unit Tests, are focused on a single portion of the system that can be verified on its own.


So Lets look at basic setup:

> Script Example:

	Here you have a simple test

		ExUnit.start - start the process

		ExUnit.configuration - load in configuration 
	
	Here you have the implementation
	
	test “name of test”  do 
		logic and assertions
	end

	scripts like this are called via `elixirc filename`

Lets Look at Structure of ExUnit

	• The main players.

	• The macros

	• The assertions

	• Context

	• Configuring ExUnit

	• ExUnit.Test Struct
	
	• ExUnit.TestModule Struct

Lets take another look at the basic example - 

	* Lets look at the macro definition of test ( meta-data )

	* Lets see how Context plays in all this.

	* The Type of Tags - and context

	* Lets look at the macro definition of describe

	- The ExUnit.TestModule does - 

	- The ExUnit.Test does - 

	- assertions

* But this not how majority of elixir apps are setup - they are all some form of 


Mix Applications - but before we talk about mix apps and testing - lets Segway a bit and talk about Boundaries.

How are they defined? * Interaction point - Ask for feedback.

What we have access in Elixir by virtue Erlang is the ability to build a lot of functional cores that communicate with each other.  We encapsulate this functionality in processes.  How do we ensure these processes we create are behaving correctly.  How do we test them.


Testing OTP examples


Testing Phoenix - 





