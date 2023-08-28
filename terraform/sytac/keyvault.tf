module "keyvault" {
  source = "../modules/keyvault"

  name                       = var.service_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  admins                     = concat(var.admins, var.service_vault_admins)
  readers                    = var.readers
  tags                       = var.tags
  purge_protection_enabled   = var.purge_protection_enabled
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}
