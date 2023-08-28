resource "random_string" "name" {
  length  = 4
  numeric = false
  upper   = false
  special = false
}

resource "azurerm_storage_account" "main" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = "West Europe"
  account_tier              = "Standard"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true
  account_replication_type  = var.replication_type
  tags                      = var.tags
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_key_vault_secret" "sa_primary_access_key" {
  name         = "sa-primary-access-key"
  key_vault_id = var.vault_id
  value        = azurerm_storage_account.main.primary_access_key

  tags = var.tags

  depends_on = [azurerm_storage_account.main]
}

resource "azurerm_key_vault_secret" "sa_primary_connection_string" {
  name         = "sa-primary-connection-string"
  key_vault_id = var.vault_id
  value        = azurerm_storage_account.main.primary_connection_string

  tags = var.tags

  depends_on = [azurerm_storage_account.main]
}
