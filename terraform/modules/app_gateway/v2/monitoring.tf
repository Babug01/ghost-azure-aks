resource "azurerm_monitor_diagnostic_setting" "app-gateway" {
  name                       = "${azurerm_application_gateway.main.name}-diagnostics"
  target_resource_id         = azurerm_application_gateway.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "metric" {
    for_each = sort(data.azurerm_monitor_diagnostic_categories.agw.metrics)
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = 0
      }
    }
  }

  dynamic "log" {
    for_each = sort(data.azurerm_monitor_diagnostic_categories.agw.logs)
    content {
      category = log.value
      enabled  = contains(var.disabled_logs, log.value) ? false : true

      retention_policy {
        enabled = contains(var.disabled_logs, log.value) ? false : true
        days    = 0
      }
    }
  }
}
