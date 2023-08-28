variable "name" {
  description = "The storage account name. This will be prepended with glvp"
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Virtual Network"
}

variable "tags" {
  description = "Any tags that should be present on the resources"
  type        = map(string)
}

variable "replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  type        = string
}

#variable "authorized_subnet_ids" {
#  description = "A list of subnet IDs authorized to access the Storage Account"
#  type        = list(string)
#}
#
#variable "authorized_ips" {
#  description = "A list of IPs to be granted Portal access"
#  type        = list(string)
#}

variable "storage_account_readers" {
  type        = list(string)
  description = "A list of user/service principal Object IDs that will have read permissions on the storage account"
}

variable "vault_id" {
  description = "The vault id that we want to store secrets in"
}
