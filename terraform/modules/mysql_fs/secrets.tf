resource "azurerm_key_vault_secret" "mysql-fs-host" {
  name         = "${var.secrets_prefix}-serviceName"
  key_vault_id = var.vault_id
  value        = azurerm_mysql_flexible_server.mysql_fs_server.name
}

resource "azurerm_key_vault_secret" "mysql-fs-username" {
  name         = "${var.secrets_prefix}-username"
  key_vault_id = var.vault_id
  value        = random_string.mysql_fs_username.result
}

resource "azurerm_key_vault_secret" "mysql-fs-password" {
  name         = "${var.secrets_prefix}-password"
  key_vault_id = var.vault_id
  value        = random_password.mysql_fs_password.result
}
