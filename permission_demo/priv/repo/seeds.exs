# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PermissionDemo.Repo.insert!(%PermissionDemo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PermissionDemo.Repo

alias PermissionDemo.Accounts.User
alias PermissionDemo.Permissions.Grant
alias PermissionDemo.Permissions.Permission

if Mix.env() == :dev do
  # Clear DB
  Repo.delete_all(Grant)
  Repo.delete_all(User)
  Repo.delete_all(Permission)

  # Create User "Kacper Wardynski"
  %{id: user_id} =
    Repo.insert!(%User{
      name: "Kacper Wardynski",
      email: "Kacper Wardynski@gmail.com",
      id: "026d26ce-28f6-4b3a-9621-53f31fc9abfc"
    })

  # Grant 200 Permissions to User Kacper Wardynski
  actions = ["read", "write", "edit", "delete"]

  for resource <- 1..50 do
    for action <- actions do
      permission_name = "resource_#{resource}:#{action}"
      %{id: permission_id} = Repo.insert!(%Permission{name: permission_name})
      Repo.insert!(%Grant{user_id: user_id, permission_id: permission_id})
    end
  end
end
