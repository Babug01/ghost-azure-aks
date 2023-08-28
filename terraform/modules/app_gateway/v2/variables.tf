variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the gateway will be created"
}

variable "location" {
  description = "The Azure Region in which to create the gateway"
  default     = "West Europe"
}

variable "virtual_network_name" {
  description = "The name of the virtual network in which the subnet is created in"
}

variable "subnet_address_prefixes" {
  description = "The address prefixes to use for the subnet"
}

variable "tags" {
  description = "Any tags that should be present on the Virtual Network resources"
  default     = {}
  type        = map(string)
}

variable "public_certificate" {
  description = "id of certificate for accepting public traffic (in keyvault)"
}

variable "backends" {
  type = list(object({
    name       = string
    fqdns      = list(string)
    host_name  = string
    probe_host = string
    probe_path = string
    protocol   = string
  }))
}

variable "applications" {
  description = "A list of applications to be routed through the gateway"
  type = list(object({
    name        = string
    hostname    = string
    backend     = string
    require_sni = bool
  }))
}

variable "log_analytics_workspace_id" {
  description = "The id of the log analytics workspace where the logs and analytics will go to"
}

variable "disabled_logs" {
  description = "A list of disabled logs"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "A list of availability zones to deploy onto"
  type        = list(string)
}

variable "max_capacity" {
  description = "The max capacity of the app gateway"
  type        = number
}

variable "agw_sku_name" {
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2."
  type        = string
}

variable "agw_sku_tier" {
  description = "The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2"
  type        = string
}

variable "agw_enable_http2" {
  description = "Is HTTP2 enabled on the application gateway resource? Defaults to false."
  type        = string
  default     = false
}
