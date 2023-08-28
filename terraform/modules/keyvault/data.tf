data "azurerm_monitor_diagnostic_categories" "vault" {
  resource_id = azurerm_key_vault.vault.id
}

