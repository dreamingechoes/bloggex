defmodule Bloggex.Accounts.Schemas.User do
  use Arc.Ecto.Schema
  use Ecto.Schema

  import Ecto.Changeset

  alias Bloggex.Accounts.Uploaders.Avatar

  schema "users" do
    field(:avatar, Avatar.Type)
    field(:biography, :string)
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:job, :string)
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:surname, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :surname,
      :email,
      :password,
      :job,
      :biography
    ])
    |> validate_required([:name, :surname, :email, :password])
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> generate_encrypted_password()
  end

  @doc false
  def avatar_changeset(user, attrs) do
    user
    |> cast_attachments(attrs, [:avatar])
  end

  defp generate_encrypted_password(%Ecto.Changeset{valid?: true} = changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        put_change(
          changeset,
          :encrypted_password,
          Comeonin.Bcrypt.hashpwsalt(password)
        )
    end
  end

  defp generate_encrypted_password(changeset), do: changeset
end
