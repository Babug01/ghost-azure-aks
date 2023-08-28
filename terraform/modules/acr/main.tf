resource "azurerm_container_registry" "acr" {
  for_each            = var.container_registries
  name                = each.key
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
  tags                = local.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_role_assignment" "acr" {
  for_each             = local.container_registry_permissions
  scope                = azurerm_container_registry.acr[each.value.registry].id
  principal_id         = each.value.user
  role_definition_name = each.value.permission
}
