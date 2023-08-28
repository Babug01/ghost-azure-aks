# VNETS for terraform

resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_cidr
  tags                = var.tags
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "k8s_subnet" {
  name                                      = "k8s-${var.project}-${var.environment}"
  resource_group_name                       = var.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.main.name
  address_prefixes                          = [var.subnets.k8s]
  private_endpoint_network_policies_enabled = true
  service_endpoints                         = var.k8s_service_endpoints
}

resource "azurerm_subnet" "reserved_ip_ingress_controller" {
  resource_group_name  = var.resource_group_name
  name                 = "ip_ingress_controller-${var.environment}"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnets.ingress_controller]
}

#resource "azurerm_role_assignment" "network-contributor-subnet" {
#  for_each = toset([for identity in module.aks.identities : identity.principal_id])
#
#  scope                = azurerm_subnet.reserved_ip_ingress_controller.id
#  role_definition_name = "Network Contributor"
#  principal_id         = each.value
#}
#
#resource "azurerm_role_assignment" "k8s-subnet" {
#  for_each = toset([for identity in module.aks.identities : identity.principal_id])
#
#  scope                = azurerm_subnet.k8s_subnet.id
#  role_definition_name = "Network Contributor"
#  principal_id         = each.value
#}
#
