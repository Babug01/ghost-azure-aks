resource "azurerm_storage_account" "main" {
  name                      = var.name
  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = data.azurerm_resource_group.main.location
  account_tier              = "Standard"
  min_tls_version           = "TLS1_2"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  tags                      = var.tags

  lifecycle {
    ignore_changes = [tags, ]
  }

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 365
    }
  }
}

resource "azurerm_role_assignment" "contributors" {
  for_each = toset(var.contributors)

  principal_id         = each.value
  role_definition_name = "Contributor"
  scope                = azurerm_storage_account.main.id
}

resource "azurerm_storage_container" "main" {
  for_each = toset(var.containers)

  name                 = each.value
  storage_account_name = azurerm_storage_account.main.name
}
