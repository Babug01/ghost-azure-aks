module "mysqlfs" {
  source = "../modules/mysql_fs"

  project              = var.project
  environment          = var.environment
  virtual_network_name = azurerm_virtual_network.main.name
  database_server_name = var.database_server_name
  resource_group_name  = var.resource_group_name
  secrets_prefix       = var.secrets_prefix
  subnets              = var.subnets
  vault_id             = module.keyvault.id
  virtual_network_id   = azurerm_virtual_network.main.id
  database_name        = var.database_name
  database_sku_name    = var.database_sku_name
  database_storage     = var.database_storage
  database_iops        = var.database_iops
  database_version     = var.database_version
  zone                 = var.zone

  charset   = "utf8mb3"
  collation = "utf8mb3_bin"

  tags = var.tags
  #firewall_rules  = var.firewall_rules

  day_of_week                       = 0
  start_hour                        = 8
  start_minute                      = 0
  enable_high_availability          = var.enable_high_availability
  mysqlfs_high_availability_mode    = "ZoneRedundant"
  mysqlfs_standby_availability_zone = "2"
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled

  alert_action_group_id = azurerm_monitor_action_group.critical.id
}
