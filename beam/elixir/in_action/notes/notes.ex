defmodule Fraction do
  defstruct a: nil, b: nil

  def new(_, 0) do
    # SOMETHING!
  end

  def new(a, b) do
    %Fraction{a: a, b: b}
  end

  def value(%Fraction{a: _, b: 0}) do
    # SOMETHING!
  end

  def value(%Fraction{a: a, b: b}) do
    a / b
  end

  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    new(a1 * b2 + a2 * b1, b2 * b1)
  end
end

# Structs and complex type assertions look like so:
# one_half = %Fraction{ a: 1, b: 2}
# faux_fract = %{ a: 1, b: 2 }
# This works:
# %Fraction{} = one_half
# This doesn't:
# %Fraction{} = faux_fract
# one_quarter = %Fraction{ a: 1, b: 4 } = %Fraction{one_half | b: 4}
# NOTE: this does work, though!
# %{a: a, b: b} = %Fraction{ a: 1, b: 2 }
# Structs are all Maps, all Maps are not Structs.

defmodule DatabaseServer do
  def start do
    spawn(fn ->
      connection = :rand.uniform(1000)
      loop(connection)
    end)
  end

  defp loop(connection) do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(connection, query_def)})
    end

    loop(connection)
  end

  defp run_query(connection, query_def) do
    Process.sleep(2000)
    "Connection: #{connection} #{query_def} result"
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  def get_result do
    receive do
      {:query_result, result} -> result
    after
      5000 ->
        {:error, :timeout}
    end
  end
end

# # Use Like:
# iex(1)> server_pid = DatabaseServer.start()
# iex(2)> DatabaseServer.run_async(server_pid, "query 1")
# iex(3)> DatabaseServer.get_result()
# iex(4)> DatabaseServer.run_async(server_pid, "query 2")
# iex(5)> DatabaseServer.get_result()

defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end)
  end

  def value(server_pid) do
    send(server_pid, {:value, self()})

    receive do
      {:response, value} ->
        value
    end
  end

  def add(server_pid, value), do: send(server_pid, {:add, value})
  def sub(server_pid, value), do: send(server_pid, {:sub, value})
  def mul(server_pid, value), do: send(server_pid, {:mul, value})
  def div(server_pid, value), do: send(server_pid, {:div, value})

  defp loop(current_value) do
    new_value =
      receive do
        {:value, caller} ->
          send(caller, {:response, current_value})
          current_value

        {:add, value} ->
          current_value + value

        {:sub, value} ->
          current_value - value

        {:mul, value} ->
          current_value * value

        {:div, value} ->
          current_value / value

        invalid ->
          IO.puts("invalid request: #{inspect(invalid)}")
          current_value
      end

    loop(new_value)
  end
end
