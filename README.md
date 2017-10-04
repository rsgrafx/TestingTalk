# Testing in Elixir

There are libraries you can test your Elixir Code with.  The official library as we all know is [ExUnit Docs](https://hexdocs.pm/ex_unit/ExUnit.html).

To Get a basic walk I suggest you look thru the docs.

The TLDR version of this link - 

In an application generated with the `mix` command test files are placed in the `test` folder.

These file need to end in a `*_test.exs` file extension this denotes that it's elixir script file.

Like a lot of other libraries ExUnit has a DSL that's goal is to help you specify in plain english the goal of components of your code.

With ExUnit you get

`describe`
`assert`
`setup`
`test`
`assert`
`assert_receive`
`capture_io and capture_log`

[Elixir School Testing ](https://elixirschool.com/en/lessons/basics/testing/)

### Scripts

### Setup in Application
