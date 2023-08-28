data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_monitor_diagnostic_categories" "aks" {
  resource_id = azurerm_kubernetes_cluster.main.id
}