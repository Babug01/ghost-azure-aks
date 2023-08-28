resource "azurerm_role_assignment" "storage-account-reader" {
  for_each = toset(var.storage_account_readers)

  scope                = azurerm_storage_account.main.id
  role_definition_name = "Reader"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "storage-account-access" {
  for_each = toset(var.storage_account_readers)

  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = each.value
}
