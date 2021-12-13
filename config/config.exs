use Mix.Config

config :swapca, github_url: "https://api.github.com"
config :swapca, send_after: 2000
config :swapca, webhook_url: "https://webhook.site/245c2373-4f76-4b1e-944b-61b13b60129b"
config :swapca, webhook_retry_after: 5000
config :swapca, webhook_max_tries: 3
 
config :logger, compile_time_purge_level: :info
