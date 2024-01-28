defmodule TodoCacheTest do
  use ExUnit.Case

  test "server_process" do
	{:ok, cache} = Todo.Cache.start()
	pup_pid = Todo.Cache.server_process(cache, "pup")

	assert pup_pid != Todo.Cache.server_process(cache, "cat")
	assert pup_pid == Todo.Cache.server_process(cache, "pup")
  end

  test "to-do operations" do
	{:ok, cache} = Todo.Cache.start()
	pup = Todo.Cache.server_process(cache, "pup")
	Todo.Server.add_entry(pup, %{date: ~D[2012-12-12], title: "wag"})
	entries = Todo.Server.entries(pup, ~D[2012-12-12])
	assert [%{date: ~D[2012-12-12], title: "wag"}] = entries
  end
end
