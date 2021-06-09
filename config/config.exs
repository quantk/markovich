use Mix.Config

config :app,
  bot_name: "Markovsky42Bot"

config :nadia,
  token: System.get_env("TG_TOKEN")

import_config "#{Mix.env}.exs"
