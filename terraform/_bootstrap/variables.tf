variable "subscription_id" {
  description = "The subscription ID where the resources will be created"
  type        = string
}

variable "storage_accounts" {
  description = "A mapping of storage accounts with their short names and contributors list"
  type = map(object({
    shortname    = string
    contributors = list(string)
    containers   = list(string)
  }))
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Virtual Network"
  type        = string
}

variable "tags" {
  description = "Any tags that should be present on the resources"
  type        = map(string)
}
