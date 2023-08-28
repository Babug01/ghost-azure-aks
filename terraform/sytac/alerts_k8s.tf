# ref: https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-metric-alerts#enable-alert-rules

resource "azurerm_monitor_metric_alert" "cpuUsagePercentage" {
  name                = "${var.project}-${var.environment}-cpuUsagePercentage-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  description         = "Cpu Usage is high"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Insights.container/nodes"
    metric_name            = "cpuUsagePercentage"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 80
    skip_metric_validation = true
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "Node CPU Usage High"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "completedJobsCount" {
  name                = "${var.project}-${var.environment}-completedJobsCount-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  description         = "When number of stale jobs older than six hours is greater than 0"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Insights.container/pods"
    metric_name            = "completedJobsCount"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 80
    skip_metric_validation = true
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "Stale Kubernetes Jobs"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "memoryWorkingSetExceededPercentage" {
  name                = "${var.project}-${var.environment}-memoryWorkingSetExceededPercentage-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  enabled             = false
  description         = "Average container working set memory is greater than 95%"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Insights.container/containers"
    metric_name            = "memoryWorkingSetExceededPercentage"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 95
    skip_metric_validation = true
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "High Mem in Containers"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "FailedPodCount" {
  name                = "${var.project}-${var.environment}-FailedPodCount-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  description         = "Failed Pod Count is greater than 1.1"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Insights.container/pods"
    metric_name            = "podCount"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 1.1
    skip_metric_validation = true

    dimension {
      name     = "phase"
      operator = "Include"
      values   = ["Failed", "Pending", "Unknown"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "Failing Pods"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "diskUsedPercentage" {
  name                = "${var.project}-${var.environment}-diskUsedPercentage-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  description         = "Average disk usage for a node is greater than 80%"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Insights.container/nodes"
    metric_name            = "diskUsedPercentage"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 80
    skip_metric_validation = true
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "Average disk usage for a node is greater than 80%"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "NotReadyNodesCount" {
  name                = "${var.project}-${var.environment}-NotReadyNodeCount-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  description         = "Number of nodes in not ready state are greater than 0"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Insights.container/nodes"
    metric_name            = "nodesCount"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 0
    skip_metric_validation = true

    dimension {
      name     = "Status"
      operator = "Include"
      values   = ["NotReady"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "Number of nodes in not ready state are greater than 0"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "memoryWorkingSetPercentage" {
  name                = "${var.project}-${var.environment}-memoryWorkingSetPercentage-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  description         = "Average node working set memory is greater than 80%"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Insights.container/nodes"
    metric_name            = "memoryWorkingSetPercentage"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 80
    skip_metric_validation = true
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "Average node working set memory is greater than 80%"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "podReadyPercentage" {
  name                = "${var.project}-${var.environment}-podReadyPercentage-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  enabled             = false
  description         = "Average ready state pods are less than 80%"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Insights.container/pods"
    metric_name            = "podReadyPercentage"
    aggregation            = "Average"
    operator               = "LessThan"
    threshold              = 80
    skip_metric_validation = true

    dimension {
      name     = "controllerName"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "Kubernetes namespace"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "Average ready state pods are less than 80%"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "restartingContainerCount" {
  name                = "${var.project}-${var.environment}-restartingContainerCount-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  description         = "Number of restarting containers are greater than 0"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 1
  tags                = var.tags

  criteria {
    metric_namespace       = "Insights.container/pods"
    metric_name            = "restartingContainerCount"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 0.5
    skip_metric_validation = true


    dimension {
      name     = "controllerName"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "Kubernetes namespace"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "Number of restarting containers are greater than 0"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "container-oom" {
  name                = "${var.project}-${var.environment}-container-oom-${random_string.alert.result}"
  resource_group_name = var.resource_group_name
  scopes              = [module.aks.id]
  description         = "Whenever the average oomkilledcontainercount is greater than 0"
  frequency           = "PT1M"
  window_size         = "PT1M"
  severity            = 0
  tags                = var.tags
  auto_mitigate       = false


  criteria {
    aggregation            = "Minimum"
    metric_name            = "oomKilledContainerCount"
    metric_namespace       = "insights.container/pods"
    operator               = "GreaterThan"
    threshold              = 0
    skip_metric_validation = true

    dimension {
      name     = "controllerName"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "Kubernetes namespace"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
    webhook_properties = {
      "name"           = "container-oom"
      "resource_group" = var.resource_group_name
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# TODO: hpa needs to be enabled before this alert is of any use
# ref: https://techcommunity.microsoft.com/t5/fasttrack-for-azure/monitor-aks-platform-with-azure-monitor-for-containers-list-of/ba-p/2382676
# Alert Name: Pod scale out (hpa)

# ref: https://techcommunity.microsoft.com/t5/fasttrack-for-azure/monitor-aks-platform-with-azure-monitor-for-containers-list-of/ba-p/2382676
resource "azurerm_monitor_scheduled_query_rules_alert" "node-scaleout" {
  name                = "${var.project}-${var.environment}-node-capacity-${random_string.alert.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [tags]
  }

  action {
    action_group           = [azurerm_monitor_action_group.critical.id]
    custom_webhook_payload = "{\"text\": \"#alertrulename fired with #searchresultcount records\", \"IncludeSearchResults\": true }"
  }

  data_source_id = azurerm_log_analytics_workspace.main.id
  description    = "Alert when Node Pool is over or under-utilised"
  enabled        = true
  # get % of node pool that is allocated & if < 20% or 90% <, raise an alert
  query = <<-QUERY
let nodepoolMaxnodeCount = ${var.k8s_node_max_count}; // the maximum number of nodes in your auto scale setting goes here.
let _minthreshold = 20;
let _maxthreshold = 90;
let startDateTime = 60m;
KubeNodeInventory
| where TimeGenerated >= ago(startDateTime)
| extend nodepoolType = todynamic(Labels) //Parse the labels to get the list of node pool types
| extend nodepoolName = todynamic(nodepoolType[0].agentpool) // parse the label to get the nodepool name or set the specific nodepool name (like nodepoolName = 'agentpool)'
| summarize nodeCount = count(Computer) by ClusterName, tostring(nodepoolName), TimeGenerated
| extend scaledpercent = iff(((nodeCount * 100 / nodepoolMaxnodeCount) <= _minthreshold and (nodeCount * 100 / nodepoolMaxnodeCount) >= _maxthreshold), "warn", "normal")
| where scaledpercent == 'warn'
| summarize arg_max(TimeGenerated, *) by nodeCount, ClusterName, tostring(nodepoolName)
| project ClusterName,
    TotalNodeCount= strcat("Total Node Count: ", nodeCount),
    ScaledOutPercentage = (nodeCount * 100 / nodepoolMaxnodeCount),
    TimeGenerated,
    nodepoolName
  QUERY

  severity    = 2
  frequency   = 10
  time_window = 30
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "rate_limit_reached" {
  name                = "${var.project}-${var.environment}-rate-limit-reached-${random_string.alert.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [tags]
  }

  action {
    action_group           = [azurerm_monitor_action_group.critical.id]
    custom_webhook_payload = "{\"text\": \"#alertrulename fired with #searchresultcount records, Rate limiting applied\", \"IncludeSearchResults\": true }"
  }

  data_source_id = azurerm_log_analytics_workspace.main.id
  description    = "${var.environment} is being rate-limited in APIM"
  enabled        = true
  # get % of node pool that is allocated & if < 20% or 90% <, raise an alert
  query = <<-QUERY
AzureDiagnostics
| where ResourceType == "APPLICATIONGATEWAYS" and OperationName == "ApplicationGatewayAccess" and httpStatus_d == 429
| summarize count() by httpStatus_d, timeStamp_t
  QUERY

  severity    = 2
  frequency   = 10
  time_window = 30
  trigger {
    operator  = "GreaterThan"
    threshold = 10
  }
}
