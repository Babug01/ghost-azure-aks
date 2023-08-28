module "ghost_storage" {
  source = "../modules/storage-account"

  name                    = var.storage_account_name
  resource_group_name     = var.resource_group_name
  replication_type        = var.replication_type
  storage_account_readers = var.storage_account_readers
  vault_id                = module.keyvault.id
  tags                    = var.tags
}

resource "azurerm_storage_container" "example" {
  name                  = var.container_name
  storage_account_name  = var.storage_account_name
  container_access_type = "blob"

  depends_on = [module.ghost_storage]
}
