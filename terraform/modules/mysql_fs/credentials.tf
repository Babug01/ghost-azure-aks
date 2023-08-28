resource "random_password" "mysql_fs_password" {
  length  = 32
  special = false
}

resource "random_string" "mysql_fs_username" {
  length  = 16
  special = false
  numeric = false
}
