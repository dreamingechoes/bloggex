defmodule Bloggex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Bloggex.Accounts.Managers.User, as: UserManager

  # User API
  defdelegate change_user(user), to: UserManager
  defdelegate create_user(attrs), to: UserManager
  defdelegate delete_user(user), to: UserManager
  defdelegate get_user_by_email!(email), to: UserManager
  defdelegate get_user!(id), to: UserManager
  defdelegate list_users, to: UserManager
  defdelegate update_user(user, attrs), to: UserManager
end
