resource "azurerm_subnet" "mysqlfs" {
  name                 = "mysqlfs-${var.project}-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.subnets.mysqlfs]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

// Enables you to manage Private DNS zones within Azure DNS
resource "azurerm_private_dns_zone" "pvt_dns" {
  name                = "${var.project}-${var.environment}.mysql.database.azure.com"
  resource_group_name = var.resource_group_name

  tags = var.tags
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "pvt_dns_vnet_link" {
  name                  = "mysqlfsVnetZone${var.project}${var.environment}.com"
  private_dns_zone_name = azurerm_private_dns_zone.pvt_dns.name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group_name

  tags = var.tags
  lifecycle {
    ignore_changes = [tags]
  }
}


#resource "azurerm_mysql_flexible_server_firewall_rule" "database_ingress_azure" {
#  name                = "internal"
#  resource_group_name = var.resource_group_name
#  server_name         = azurerm_mysql_flexible_server.mysql_fs_server.name
#  start_ip_address    = "0.0.0.0"
#  end_ip_address      = "0.0.0.0"
#}
#
#resource "azurerm_mysql_flexible_server_firewall_rule" "database_ingress_others" {
#  for_each = var.firewall_rules
#
#  name                = each.key
#  resource_group_name = var.resource_group_name
#  server_name         = azurerm_mysql_flexible_server.mysql_fs_server.name
#  start_ip_address    = each.value.start_ip_address
#  end_ip_address      = each.value.end_ip_address
#}
