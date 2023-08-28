resource "azurerm_application_insights" "service-analytics" {
  name                = "${var.project}-service-analytics-${var.environment}"
  location            = "West Europe"
  resource_group_name = var.resource_group_name
  application_type    = "Node.JS"

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_key_vault_secret" "app-insights-connection-string" {
  name         = "app-insights-connection-string"
  key_vault_id = module.keyvault.id
  value        = azurerm_application_insights.service-analytics.connection_string

  tags = var.tags

  depends_on = [module.keyvault]
}

resource "azurerm_key_vault_secret" "instrumentation_key" {
  name         = "app-insights-instrumentationkey"
  key_vault_id = module.keyvault.id
  value        = azurerm_application_insights.service-analytics.instrumentation_key

  tags = var.tags

  depends_on = [module.keyvault]
}
