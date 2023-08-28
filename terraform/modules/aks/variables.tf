variable "resource_group_name" {
  description = "The name of the Resource Group in which the Virtual Network"
}

variable "location" {
  description = "The Azure Region in which to create the Virtual Network"
  default     = "West Europe"
}

#kubernetes variables
variable "kubernetes_cluster_name" {
  description = "The name of the aks cluster"
  type        = string
}

variable "controlplane_version" {
  description = "Version of Kubernetes Control Plane to manage"
}

variable "nodepool_version" {
  description = "Version of Kubernetes orchestrator for node pools"
}

variable "enable_sla" {
  description = "Whether or not to enable SLA on the cluster"
  default     = false
}

variable "enable_auto_scaling" {
  description = "Whether or not to enable Auto scaling on the cluster nodepool"
  default     = false
}


variable "default_pool_vm_size" {
  description = "The SKU which should be used for the Virtual Machines used in this Node Pool. Changing this forces a new resource to be created"
  default     = "Standard_D2_v2"
}

variable "default_pool_max_pods" {
  description = "The maximum number of pods that can run on each agent. Changing this forces a new resource to be created"
  default     = "32"
}

variable "default_pool_count" {
  description = "The number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100"
  default     = 1
}

variable "node_max_count" {
  description = "The number of nodes which should exist in this Node Pool. During auto scaling, If specified this must be between 1 and 100"
  default     = 3
}

variable "node_min_count" {
  description = "The number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100"
  default     = 1
}

variable "subnet_id" {
  description = "The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created"
}

variable "default_pool_disk_size" {
  description = "The size of the OS Disk which should be used for each agent in the Node Pool. Changing this forces a new resource to be created"
  default     = 100
}

variable "tags" {
  description = "Any tags that should be present on the Virtual Network resources"
  default     = {}
  type        = map(string)
}

variable "enable_managed_identity" {
  description = "Indicates to use of a managed identity for the AKS cluster"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "List of availability zones to deploy onto"
  type        = list(number)
}

variable "log_analytics_workspace_id" {
  description = "The id of the log analytics workspace where the logs and analytics will go to"
  type        = string
}

variable "disabled_logs" {
  description = "A list of disabled logs"
  type        = list(string)
  default = [
    "kube-audit",
    "kube-audit-admin"
  ]
}
