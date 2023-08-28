resource "azurerm_kubernetes_cluster" "main" {

  name                = var.kubernetes_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.kubernetes_cluster_name
  kubernetes_version  = var.controlplane_version
  sku_tier            = var.enable_sla ? "Paid" : "Free"

  # If we update the max_pods it would trigger a full cluster re-creation. To
  # prevent this to happend, we created a secondary node pool
  # Feature to scale down to 0 node will come in Q2 2020
  # Ref: https://github.com/Azure/AKS/issues/1050
  default_node_pool {
    name                  = "default"
    type                  = "VirtualMachineScaleSets"
    vm_size               = var.default_pool_vm_size
    enable_auto_scaling   = var.enable_auto_scaling
    enable_node_public_ip = false
    max_pods              = 32
    node_count            = 1
    max_count             = var.node_max_count
    min_count             = var.node_min_count
    vnet_subnet_id        = var.subnet_id
    os_disk_size_gb       = 100
    orchestrator_version  = var.nodepool_version

    upgrade_settings {
      max_surge = "33%"
    }
    temporary_name_for_rotation = "tempnodepool"
  }

  role_based_access_control_enabled = true

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = []
  }

  dynamic "identity" {
    for_each = var.enable_managed_identity ? [true] : []

    content {
      type = "SystemAssigned"
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  azure_policy_enabled             = true
  http_application_routing_enabled = false

  tags = var.tags
  lifecycle {
    ignore_changes = [tags]
  }
}
