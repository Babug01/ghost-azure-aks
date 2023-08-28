data "azurerm_monitor_diagnostic_categories" "agw" {
  resource_id = azurerm_application_gateway.main.id
}
