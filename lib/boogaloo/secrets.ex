defmodule Boogaloo.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        Boogaloo.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:boogaloo, :token_signing_secret)
  end
end
