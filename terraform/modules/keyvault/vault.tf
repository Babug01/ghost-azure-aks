resource "random_string" "name" {
  length  = 4
  numeric = false
  upper   = false
  special = false
}

resource "azurerm_key_vault" "vault" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  sku_name                    = "standard"
  tenant_id                   = var.tenant_id
  enabled_for_disk_encryption = true
  purge_protection_enabled    = var.purge_protection_enabled
  tags                        = var.tags

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags]
  }

}

resource "azurerm_key_vault_access_policy" "admins" {
  for_each = toset(var.admins)

  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = azurerm_key_vault.vault.tenant_id
  object_id    = each.value

  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "ManageIssuers",
    "GetIssuers",
    "ListIssuers",
    "SetIssuers",
    "DeleteIssuers",
    "Purge"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]
}

resource "azurerm_key_vault_access_policy" "readers" {
  for_each = toset(var.readers)

  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = azurerm_key_vault.vault.tenant_id
  object_id    = each.value

  key_permissions = [
    "Get",
    "List",
  ]

  certificate_permissions = [
    "Get",
    "List",
    "ListIssuers",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]
}
