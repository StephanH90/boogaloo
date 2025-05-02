defmodule Boogaloo.Repo do
  use AshSqlite.Repo,
    otp_app: :boogaloo
end
