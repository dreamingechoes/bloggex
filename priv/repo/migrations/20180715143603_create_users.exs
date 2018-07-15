defmodule Bloggex.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:avatar, :string)
      add(:biography, :text)
      add(:email, :string)
      add(:encrypted_password, :string)
      add(:job, :string)
      add(:name, :string)
      add(:surname, :string)

      timestamps()
    end
  end
end
