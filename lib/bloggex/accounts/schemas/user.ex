defmodule Bloggex.Accounts.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field(:avatar, :string)
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
      :avatar,
      :job,
      :biography
    ])
    |> validate_required([:name, :surname, :email, :password])
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> generate_encrypted_password()
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
