variable "environment" {
  type = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "location" {
  description = "The default location to deploy within this configuration"
  type        = string
}

variable "tag_environment" {
  description = "Environment tag for resources"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Any tags that should be present on the resources"
  type        = map(string)
}

variable "container_registries" {
  description = "List of container registries to create"
  type = map(object({
    AcrPull = list(string)
    AcrPush = list(string)
    Reader  = list(string)
  }))
}
