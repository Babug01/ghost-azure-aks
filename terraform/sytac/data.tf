data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {
}

data "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "ai_connectin_string" {
  name         = "app-insights-connection-string"
  key_vault_id = module.keyvault.id
}

data "azurerm_key_vault_secret" "ai_instrumentation_key" {
  name         = "app-insights-instrumentationkey"
  key_vault_id = module.keyvault.id
}

data "azurerm_key_vault_secret" "primary_access_key" {
  name         = "sa-primary-access-key"
  key_vault_id = module.keyvault.id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

output "object_id" {
  value = data.azurerm_client_config.current.object_id
}
