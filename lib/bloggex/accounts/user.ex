defmodule Bloggex.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field(:avatar, :string)
    field(:biography, :string)
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:job, :string)
    field(:name, :string)
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
      :encrypted_password,
      :avatar,
      :job,
      :biography
    ])
    |> validate_required([
      :name,
      :surname,
      :email,
      :encrypted_password
    ])
  end
end
