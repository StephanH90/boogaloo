# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Boogaloo.Repo.insert!(%Boogaloo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Import Context7 example user creation script
IO.puts("Creating example user with Context7 integration...")

alias Boogaloo.Accounts.User
alias Boogaloo.Blogs.Blog

# Create an example user with Context7 documentation using the testing approach
# Generate a unique email with timestamp to avoid conflicts
timestamp = DateTime.utc_now() |> DateTime.to_unix()
email = "example-#{timestamp}@context7.com"
password = "SecurePassword123!"
{:ok, hashed_password} = AshAuthentication.BcryptProvider.hash(password)

# Seed the user with the hashed password
user = Ash.Seed.seed!(User, %{
  email: email,
  hashed_password: hashed_password
})

IO.puts("Example user created successfully with ID: #{user.id}")

# Create a sample blog post associated with the user
# Using Ash.Seed.seed! to bypass action requirements
blog = Ash.Seed.seed!(Blog, %{
  title: "Getting Started with Context7",
  body: """
  # Introduction to Context7
  
  Context7 is a powerful tool for providing up-to-date documentation for LLMs and AI code editors.
  
  This blog post demonstrates how to integrate Context7 with your Elixir application.
  
  ## Key Features
  
  - Contextual documentation
  - AI-friendly interfaces
  - Easy integration with existing codebases
  """,
  user_id: user.id,
  published_at: DateTime.utc_now()
})

IO.puts("Blog post created successfully with ID: #{blog.id}")

# Print summary of created entities
IO.puts("\nSummary of created entities:")
IO.puts("----------------------------")
IO.puts("User: #{user.email}")
IO.puts("Blog: #{blog.title}")
IO.puts("Created at: #{DateTime.utc_now()}")
