defmodule PermissionDemo.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PermissionDemo.Repo

  alias PermissionDemo.Accounts.User
  alias PermissionDemo.Permissions.Grant

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    from(u in User, preload: :permissions)
    |> Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    from(u in User,
      where: [id: ^id],
      preload: :permissions
    )
    |> Repo.one!()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    with(
      changeset <- User.changeset(%User{}, attrs),
      {:ok, %User{} = user} <- Repo.insert(changeset),
      user = Repo.preload(user, :permissions)
    ) do
      {:ok, user}
    end
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns a list of ALL Permissions granted to a User
  """
  def available_permissions(user_id) do
    from(grant in Grant,
      join: user in assoc(grant, :user),
      join: permission in assoc(grant, :permission),
      where: user.id == ^user_id,
      select: permission.name
    )
    |> Repo.all()
  end

  @doc """
  Returns the union of a reference list and the Permissions granted to a User
  """
  def matching_permissions(user_id, reference_permissions) do
    from(grant in Grant,
      join: user in assoc(grant, :user),
      join: permission in assoc(grant, :permission),
      where: user.id == ^user_id,
      where: permission.name in ^reference_permissions,
      select: permission.name
    )
    |> Repo.all()
  end
end
