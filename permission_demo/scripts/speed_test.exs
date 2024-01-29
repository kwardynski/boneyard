defmodule SpeedTest do
  alias PermissionDemo.Accounts
  alias PermissionDemo.Permissions

  def random_permission_name() do
    actions = ["read", "write", "edit", "delete"]
    "resource_#{:rand.uniform(100)}:#{Enum.random(actions)}"
  end

  def time_validation(method, user_id, permissions) do
    {call_time, _validated_permissions} =
      :timer.tc(fn -> validate_permissions(method, user_id, permissions) end)
    call_time
  end

  def mean(data), do: Enum.sum(data) / length(data)

  defp validate_permissions("slow", user_id, permissions) do
    user_id
    |> Accounts.available_permissions()
    |> Permissions.permissions_granted?(permissions)
  end

  defp validate_permissions("fast", user_id, permissions) do
    user_id
    |> Accounts.matching_permissions(permissions)
    |> Permissions.permissions_granted?(permissions)
  end
end

attempts = 100
num_permissions = 20
user_id = "026d26ce-28f6-4b3a-9621-53f31fc9abfc"

reference_permissions = for _ <- 1..num_permissions, do: SpeedTest.random_permission_name()

slow_average =
  1..attempts
  |> Enum.map(fn _x -> SpeedTest.time_validation("slow", user_id, reference_permissions) end)
  |> SpeedTest.mean()

fast_average =
  1..attempts
  |> Enum.map(fn _x -> SpeedTest.time_validation("fast", user_id, reference_permissions) end)
  |> SpeedTest.mean()

speed_increase = :erlang.float_to_binary(slow_average/fast_average, [decimals: 3])

IO.puts("slow method average for #{attempts} attempts: #{slow_average} uSec")
IO.puts("fast method average for #{attempts} attempts: #{fast_average} uSec")
IO.puts("fast method is #{speed_increase}x faster!")
