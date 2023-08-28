resource "random_string" "name" {
  length  = 4
  numeric = false
  upper   = false
  special = false
}

resource "azurerm_mysql_flexible_server" "mysql_fs_server" {
  name                = var.database_server_name
  location            = var.location
  resource_group_name = var.resource_group_name

  delegated_subnet_id = azurerm_subnet.mysqlfs.id
  private_dns_zone_id = azurerm_private_dns_zone.pvt_dns.id

  administrator_login    = random_string.mysql_fs_username.result
  administrator_password = random_password.mysql_fs_password.result

  zone    = var.zone
  version = var.database_version

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  create_mode                  = "Default"


  storage {
    auto_grow_enabled = var.auto_grow_enabled
    size_gb           = var.database_storage
    iops              = var.database_iops
  }

  sku_name = var.database_sku_name

  dynamic "high_availability" {
    for_each = (var.enable_high_availability ? [1] : [])
    content {
      mode                      = var.mysqlfs_high_availability_mode
      standby_availability_zone = var.mysqlfs_standby_availability_zone
    }
  }

  maintenance_window {
    day_of_week  = var.day_of_week
    start_hour   = var.start_hour
    start_minute = var.start_minute
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.pvt_dns_vnet_link]

}

resource "azurerm_mysql_flexible_database" "database" {
  for_each = var.database_name

  name                = each.value.shortname
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_fs_server.name
  charset             = var.charset
  collation           = var.collation
}

resource "azurerm_mysql_flexible_server_configuration" "wait_timeout" {
  name                = "interactive_timeout"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_fs_server.name
  value               = "600"
}
