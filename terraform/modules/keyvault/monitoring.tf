resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = "${azurerm_key_vault.vault.name}-diagnostics"
  target_resource_id         = azurerm_key_vault.vault.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "metric" {
    for_each = sort(data.azurerm_monitor_diagnostic_categories.vault.metrics)
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  dynamic "log" {
    for_each = sort(data.azurerm_monitor_diagnostic_categories.vault.logs)
    content {
      category = log.value
      enabled  = contains(var.disabled_logs, log.value) ? false : true

      retention_policy {
        enabled = true
        days    = 0
      }
    }
  }
}
