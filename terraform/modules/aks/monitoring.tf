resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "${azurerm_kubernetes_cluster.main.name}-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "metric" {
    for_each = sort(data.azurerm_monitor_diagnostic_categories.aks.metrics)
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
    for_each = sort(data.azurerm_monitor_diagnostic_categories.aks.logs)
    content {
      category = log.value
      enabled  = contains(var.disabled_logs, log.value) ? false : true

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }
}
