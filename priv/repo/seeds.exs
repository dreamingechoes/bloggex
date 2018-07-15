alias Bloggex.Accounts

# Create a default user
Accounts.create_user(%{
  email: "admin@example.com",
  password: "123456",
  name: "Example",
  surname: "Example"
})
