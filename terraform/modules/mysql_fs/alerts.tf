resource "random_string" "uniq" {
  length  = 4
  special = false
  numeric = false
}

resource "azurerm_monitor_metric_alert" "cpuPercent" {
  name                = "cpuPercentage-${random_string.uniq.result}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_mysql_flexible_server.mysql_fs_server.id]
  description         = "MYSQL CPU Percentage is high in '${var.database_server_name}' ResourceGroup: ${var.resource_group_name}"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Microsoft.DBforMySQL/flexibleServers"
    metric_name            = "cpu_percent"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 50
    skip_metric_validation = true
  }

  action {
    action_group_id = var.alert_action_group_id
    webhook_properties = {
      "name"           = "MYSQL CPU Percentage is high in '${var.database_server_name}' ResourceGroup: ${var.resource_group_name}"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "memoryPercentage" {
  name                = "memoryPercentage-${random_string.uniq.result}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_mysql_flexible_server.mysql_fs_server.id]
  description         = "MYSQL Memory Percentage is high in '${var.database_server_name}' ResourceGroup: ${var.resource_group_name}"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Microsoft.DBforMySQL/flexibleServers"
    metric_name            = "memory_percent"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 50
    skip_metric_validation = true
  }

  action {
    action_group_id = var.alert_action_group_id
    webhook_properties = {
      "name"           = "MYSQL Memory Percentage is high in '${var.database_server_name}' ResourceGroup: ${var.resource_group_name}"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "IOConsumptionPercentage" {
  name                = "IOConsumptionPercentage-${random_string.uniq.result}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_mysql_flexible_server.mysql_fs_server.id]
  description         = "MYSQL IO-Consumption Percentage is high in '${var.database_server_name}' ResourceGroup: ${var.resource_group_name}"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Microsoft.DBforMySQL/flexibleServers"
    metric_name            = "io_consumption_percent"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 50
    skip_metric_validation = true
  }

  action {
    action_group_id = var.alert_action_group_id
    webhook_properties = {
      "name"           = "MYSQL IO-Consumption Percentage is high in '${var.database_server_name}' ResourceGroup: ${var.resource_group_name}"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "storagePercentage" {
  name                = "storagePercentage-${random_string.uniq.result}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_mysql_flexible_server.mysql_fs_server.id]
  description         = "MYSQL Storage Percentage is high in '${var.database_server_name}' ResourceGroup: ${var.resource_group_name}"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Microsoft.DBforMySQL/flexibleServers"
    metric_name            = "storage_percent"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 50
    skip_metric_validation = true
  }

  action {
    action_group_id = var.alert_action_group_id
    webhook_properties = {
      "name"           = "MYSQL Storage Percentage is high in '${var.database_server_name}' ResourceGroup: ${var.resource_group_name}"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
