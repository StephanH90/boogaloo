defmodule Boogaloo.Accounts do
  use Ash.Domain, otp_app: :boogaloo, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Boogaloo.Accounts.Token

    resource Boogaloo.Accounts.User do
      define :list_users, action: :read
    end
  end
end
