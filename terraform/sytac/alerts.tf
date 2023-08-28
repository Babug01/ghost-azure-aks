resource "random_string" "alert" {
  length  = 4
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_monitor_action_group" "critical" {
  name                = "${var.project}-${var.environment}-critical"
  resource_group_name = var.resource_group_name
  short_name          = "critical"
  enabled             = true
  tags                = var.tags

  email_receiver {
    name                    = "sendtoslack"
    email_address           = "infra-azure-alerts-aaaahg7raam2fxgw72uda3a6am@grandvisionit.slack.com"
    use_common_alert_schema = true
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "availability" {
  name                = "${var.project}-${var.environment}-availability-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.service-analytics.id]
  description         = "Average availability is less than or equal to 95% in the last 30 mins"
  frequency           = "PT5M"
  window_size         = "PT30M"
  severity            = 0
  tags                = var.tags

  criteria {
    aggregation      = "Average"
    metric_name      = "availabilityResults/availabilityPercentage"
    metric_namespace = "microsoft.insights/components"
    operator         = "LessThanOrEqual"
    threshold        = 95
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "availability"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
