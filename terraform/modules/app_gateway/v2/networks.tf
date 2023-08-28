resource "azurerm_subnet" "frontend" {
  name                 = "gw-subnet-${var.prefix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "main" {
  name                = "gw-pbip-${var.prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
  zones               = ["1", "2", "3"]

  lifecycle {
    ignore_changes = [tags]
  }
}
