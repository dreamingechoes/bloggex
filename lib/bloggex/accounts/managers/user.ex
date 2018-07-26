defmodule Bloggex.Accounts.Managers.User do
  import Ecto.Query, warn: false

  alias Bloggex.Accounts.Schemas.User
  alias Bloggex.Accounts.Uploaders.Avatar
  alias Bloggex.Repo
  alias Bloggex.Uploaders.Uploader
  alias Ecto.Multi

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
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
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by email.

  Raises `Ecto.NoResultsError` if the user does not exist.

  ## Examples

      iex> get_user_by_email!("some@email.com")
      %user{}

      iex> get_user_by_email!("some@email.com")
      ** (Ecto.NoResultsError)
  """
  def get_user_by_email!(email) do
    Repo.one!(from(u in User, where: u.email == ^email))
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
    result =
      Multi.new()
      |> Multi.insert(:user, User.changeset(%User{}, attrs))
      |> Multi.run(:avatar, &create_avatar(&1, attrs))
      |> Repo.transaction()

    case result do
      {:ok, changes} -> {:ok, changes.user}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    result =
      case is_nil(Map.get(attrs, "avatar")) do
        false ->
          # We only want to update the avatar if the attr is sent
          Multi.new()
          |> Multi.update(:user, User.update_changeset(user, attrs))
          |> Multi.run(:old_avatar, &delete_avatar(&1))
          |> Multi.run(:avatar, &create_avatar(&1, attrs))

        true ->
          Multi.new()
          |> Multi.update(:user, User.update_changeset(user, attrs))
      end

    case Repo.transaction(result) do
      {:ok, changes} -> {:ok, changes.user}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    result =
      Multi.new()
      |> Multi.delete(:user, user)
      |> Multi.run(:avatar, &delete_avatar(&1))
      |> Repo.transaction()

    case result do
      {:ok, changes} -> {:ok, changes.user}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  defp create_avatar(%{user: user}, attrs) do
    user
    |> User.avatar_changeset(attrs)
    |> Repo.update()
  end

  defp delete_avatar(%{user: user}) do
    path = Uploader.file_path(user, user.avatar, Avatar)

    case Avatar.delete({path, user}) do
      :ok -> {:ok, user}
      _ -> {:error, user}
    end
  end
end
