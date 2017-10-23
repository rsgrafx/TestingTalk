defmodule LearningRedirectingWeb.Router do
  use LearningRedirectingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  get "/foobar", Redirector, to: "/baz"
  get "/search", Redirector, external: "http://duckduckgo.com/?q=Fiji&ia=images&iax=1"
  get "/search/:name", Redirector, external: "http://duckduckgo.com/?q=Fiji&ia=images&iax=1"

  get "/exceptionator", Redirector, []

  scope "/api", LearningRedirectingWeb do
    pipe_through :api
  end
end
