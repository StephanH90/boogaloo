import Config

config :boogaloo, Boogaloo.Web.Endpoint,
  watchers: [
    sass:
      {DartSass, :install_and_run,
       [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]}
  ]
