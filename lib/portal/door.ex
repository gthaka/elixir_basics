defmodule Portal.Door do
  use Agent

  def start_link(color) when is_atom(color) do
    Agent.start_link(fn -> [] end, name: color)
  end

  def get(door) do
    Agent.get(door, fn list -> list end)
  end

  def push(door, value) do
    Agent.update(door, fn list -> [value | list] end)
  end

  def pop(door) do
    Agent.get_and_update(door, fn list ->
      case list do
        [h | t] -> {{:ok, h}, t}
        [] -> {:error, []}
      end
    end)
  end

  def stop(door) do
    Agent.stop(door)
  end
end
