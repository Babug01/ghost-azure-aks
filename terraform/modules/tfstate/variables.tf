variable "resource_group" {
  type        = string
  description = "Name of the resource group where the storage account will be placed"
}

variable "name" {
  type        = string
  description = "A name for the storage account"
}

variable "contributors" {
  type        = list(string)
  description = "A list of service principals that need contributor access to the state storage account"
}

variable "containers" {
  type        = list(string)
  description = "A list of containers to be created in the storage account"
}

variable "tags" {
  description = "Any tags that should be present on the resources"
  type        = map(string)
}
