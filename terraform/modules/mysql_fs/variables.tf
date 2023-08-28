variable "project" {
  description = "The name of the project that is being provisioned"
  type        = string
}

variable "environment" {
  description = "The environment ot provision/configure Terraform resources"
  type        = string
}

variable "database_server_name" {
  description = "Name of the database server"
}

variable "secrets_prefix" {
  description = "Prefix for secrets"
}

variable "resource_group_name" {
  description = "name of the resource group"
}

variable "database_sku_name" {
  description = "The SKU Name for the MySQL Flexible Server"
}

variable "database_version" {
  description = "The version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21. Changing this forces a new MySQL Flexible Server to be created."
}

variable "database_storage" {
  description = "The max storage allowed for the MySQL Flexible Server. Possible values are between 20 and 16384."
}

variable "database_iops" {
  description = "The storage IOPS for the MySQL Flexible Server. Possible values are between 360 and 20000"
}

variable "tags" {
  description = "Tags to apply to the services"
}

variable "charset" {
  description = "Specifies the charset of the database"
  type        = string
}

variable "collation" {
  description = "Specifies the collation of the database"
  type        = string
}

#variable "firewall_rules" {
#  description = "Map the individual firewall rule for each person who needs access to database"
#  type = map(object({
#    start_ip_address = string
#    end_ip_address   = string
#  }))
#}

variable "vault_id" {
  description = "The vault id that we want to store secrets in"
}

variable "tag_environment" {
  description = "Environment tag for resources"
  type        = string
  default     = ""
}

variable "enable_high_availability" {
  description = "A boolean to determine whether to enable High Availability or not"
  type        = bool
}

variable "mysqlfs_high_availability_mode" {
  description = "The high availability mode for the MySQL Flexible Server. Possibles values are SameZone and ZoneRedundant."
  type        = string
}

variable "mysqlfs_standby_availability_zone" {
  description = " Specifies the Availability Zone in which the standby Flexible Server should be located. Possible values are 1, 2 and 3."
}

variable "database_name" {
  description = "Name of the database"
  type = map(object({
    shortname = string
  }))
}

variable "zone" {
  description = "Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3."
}

variable "day_of_week" {
  description = "The day of week for maintenance window. Defaults to 0."
}

variable "start_hour" {
  description = "The start hour for maintenance window. Defaults to 0."
}

variable "start_minute" {
  description = "The start minute for maintenance window. Defaults to 0."
}

variable "virtual_network_name" {
  description = "Vnet Name"
  type        = string
}

variable "virtual_network_id" {
  description = "VNET ID"
  type        = string
}

variable "subnets" {
  description = "Map of subnets and their cidrs"
  type        = map(string)
}

variable "location" {
  description = "The Azure Region where the MySQL Flexible Server should exist. Changing this forces a new MySQL Flexible Server to be created."
  type        = string
  default     = "West Europe"
}

variable "backup_retention_days" {
  description = "The backup retention days for the MySQL Flexible Server. Possible values are between 7 and 35 days."
  type        = string
  default     = "7"
}

variable "geo_redundant_backup_enabled" {
  description = "Is Geo-Redundant backup enabled on the MySQL Flexible Server. Defaults to false. Changing this forces a new MySQL Flexible Server to be created."
  type        = string
  default     = "false"
}

variable "auto_grow_enabled" {
  description = "Should Storage Auto Grow be enabled? Defaults to true."
  type        = string
  default     = "true"
}

variable "alert_action_group_id" {
  description = "An ID of the alert group that this cosmosdb account should use"
  type        = string
}
