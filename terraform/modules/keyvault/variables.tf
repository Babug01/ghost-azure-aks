variable "name" {
  type        = string
  description = "Name of the vault"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id"
}

variable "location" {
  type        = string
  description = "Resource location"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "admins" {
  type        = list(string)
  description = "List of administrators object id"
}

variable "readers" {
  type        = list(string)
  description = "List of readers object id"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}

variable "purge_protection_enabled" {
  description = "Is Purge Protection enabled for this Key Vault?"
  type        = bool
  default     = true
}

variable "tag_environment" {
  description = "Environment tag for resources"
  type        = string
  default     = ""
}

variable "log_analytics_workspace_id" {
  description = "The id of the log analytics workspace where the logs and analytics will go to"
  type        = string
}

variable "disabled_logs" {
  description = "A list of disabled logs"
  type        = list(string)
  default     = []
}
