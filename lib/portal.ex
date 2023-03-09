defmodule Portal do
  defstruct [:left, :right]

  def shoot(color) do
    Portal.Door.start_link(color)
  end

  def transfer(left_door, right_door, data) do
    # First add all data to the portal on the left
    for item <- data do
      Portal.Door.push(left_door, item)
    end

    # Returns a portal struct with the doors
    %Portal{left: left_door, right: right_door}
  end

  def push_right(portal) do
    # See if we can pop data from left. If so, push the
    # popped data to the right. Otherwise, do nothing.
    case Portal.Door.pop(portal.left) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(portal.right, h)
    end

    # Let's return the portal itself
    portal
  end

  def close(portal) do
    Portal.Door.stop(portal.left)
    Portal.Door.stop(portal.right)
    :ok
  end

  defimpl Inspect, for: Portal do
    def inspect(%Portal{left: left, right: right}, _) do
      left_door = inspect(left)
      right_door = inspect(right)

      left_data = inspect(Enum.reverse(Portal.Door.get(left)))
      right_data = inspect(Portal.Door.get(right))

      max = max(String.length(left_door), String.length(left_data))

      """
      #Portal<
        #{String.pad_leading(left_door, max)} <=> #{right_door}
        #{String.pad_leading(left_data, max)} <=> #{right_data}
      >\
      """
    end
  end
end
