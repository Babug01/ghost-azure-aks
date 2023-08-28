subscription_id     = ""
resource_group_name = ""

storage_accounts = {
  base = {
    shortname    = "satfsateghost",
    contributors = []
    containers = [
      "bootstrap",
      "prod",
      "nonprod",
    ]
  },
}

tags = {
  Application = "Ghost"
  Department  = "R&D"
  Owner       = "Babu Ganesan"
}

