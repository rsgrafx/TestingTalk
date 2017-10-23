defmodule Redirector do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]

  def init([to: _opts] = opts), do: opts
  def init([external: _] = opts), do: opts

  def init(_), do: raise("Missing `to:` or `external:` keyword option")

  def call(conn, [to: opts]) do
    conn |> redirect(to: append_query_string(conn, opts))
  end

  def call(conn, [external: url]) do
    external = url
      |> URI.parse
      |> merge_query_string(conn)
      |> URI.to_string

    redirect(conn, external: external)
  end

  defp append_query_string(%{query_string: ""}, path), do: path
  defp append_query_string(%{query_string: query}, path) do
    query =
    String.split(query, "&")
    |> Enum.map(fn(q) ->
      keyword_to_q(q)
    end)
    |> Enum.join("?")

    "#{path}?#{query}"
  end

  def keyword_to_q("keyword=" <> value), do: "q=#{value}"
  def keyword_to_q(any), do: any

  def merge_query_string(%{query: dest} = uri_map, %{query_string: source, path_params: values} = conn) do
    queries = URI.decode_query(source)

    override = fn
      %{"name" => name }, queries -> Map.merge(queries, %{"q" => name })
      _, queries -> queries
    end

    merged = Map.merge(
      (URI.decode_query(dest)),
      override.(values, URI.decode_query(source))
    )
    %{ uri_map | query: URI.encode_query(merged)}
  end

end

defmodule RedirectorTest do
  use LearningRedirectingWeb.ConnCase
  alias LearningRedirectingWeb.Router

  test "route redirected to internal route" do
    conn = call(Router, :get, "/foobar")

    assert conn.status == 302
    assert String.contains?(conn.resp_body, "/baz")
  end

  test "route redirected to internal route with query string" do
    conn = call(Router, :get, "/foobar?example_query=stars")
    assert_redirected_to(conn, "/baz?example_query=stars")
    assert conn.status == 302
    assert String.contains?(conn.resp_body, "/baz?example_query=stars")
  end

  test "an exception is raised when to is not defined" do
    assert_raise Plug.Conn.WrapperError, ~R[Missing `to:` or `external:` keyword option], fn ->
      call(Router, :get, "/exceptionator")
    end
  end

  test "routes to an external route" do
    conn = call(Router, :get, "/search?q=Miami")
    assert_redirected_to(conn, "http://duckduckgo.com/?q=Miami&ia=images&iax=1")
  end

  test "routes to an external route second try" do
    conn = call(Router, :get, "/search?q=Belize")
    assert_redirected_to(conn, "http://duckduckgo.com/?q=Belize&ia=images&iax=1")
  end

  test "routes to an external route - restful search" do
    conn = call(Router, :get, "/search/Miami")
    assert_redirected_to(conn, "http://duckduckgo.com/?q=Miami&ia=images&iax=1")
  end

  test "routes to an external route - restful search override" do
    conn = call(Router, :get, "/search/Miami?q=Tuna")
    assert_redirected_to(conn, "http://duckduckgo.com/?q=Miami&ia=images&iax=1")
  end

  def assert_redirected_to(conn, expected_url) do
    actual_uri = conn
      |> Plug.Conn.get_resp_header("location")
      |> List.first()
      |> URI.parse()

      expected_uri = URI.parse(expected_url)

      assert conn.status == 302
      assert actual_uri.scheme == expected_uri.scheme
      assert actual_uri.host == expected_uri.host
      assert actual_uri.path == expected_uri.path

      if actual_uri.query do
        assert Map.equal?(
          URI.decode_query(actual_uri.query),
          URI.decode_query(expected_uri.query)
        )
      end
  end

  def call(router, verb, path) do
    verb
    |> Plug.Test.conn(path)
    |> router.call(router.init([]))
  end
end