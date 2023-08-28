variable "subscription_id" {
  description = "The subscription where the resources will be placed"
  type        = string
}

variable "environment" {
  description = "The environment ot provision/configure Terraform resources"
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

variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "project" {
  description = "The name of the project that is being provisioned"
  type        = string
}

# acr variables
variable "container_registries" {
  description = "List of container registries to create"
  type = map(object({
    AcrPull = list(string)
    AcrPush = list(string)
    Reader  = list(string)
  }))
}

variable "container_registry_name" {
  description = "The name of the ACR that is being provisioned"
  type        = string
}


variable "virtual_network_name" {
  description = "Subnet Name for each k8s instance"
  type        = string
}

variable "subnets" {
  description = "Map of subnets and their cidrs"
  type        = map(string)
}

variable "kubernetes_cluster_name" {
  description = "The name of the aks cluster"
  type        = string
}

variable "k8s_controlplane_version" {
  description = "The Kubernetes version for the AKS cluster"
}

variable "k8s_nodepool_version" {
  description = "The Kubernetes version used for the AKS cluster node pools"
}

variable "k8s_enable_sla" {
  description = "Boolean to decide whether or not to enable SLA on the AKS cluster"
  type        = bool
}

variable "k8s_cluster_fqdn" {
  description = "FQDN name for AKS cluster"
  type        = string
}

variable "namespaces" {
  description = "A list of namespaces to be created in Kubernetes"
  type        = list(string)
}

variable "k8s_enable_managed_identity" {
  description = "Indicates to use of a managed identity for the AKS cluster"
  type        = bool
  default     = false
}

variable "enforce_azure_policies" {
  description = "A boolean to determine whether to enforce azure policies or not"
  type        = bool
}

variable "deployment_service_principal_ids" {
  description = "Object id of the service-principal used to deploy out into the k8s cluster"
  type        = list(string)
}

variable "aks_admin_group_object_ids" {
  description = "Defines which Active Directory groups have admin access to the cluster"
  type        = list(string)
}

variable "aks_reader_group_object_ids" {
  description = "Defines which Active Directory groups have admin access to the cluster"
  type        = list(string)
}

variable "developer_role" {
  description = "the role to apply to developers in this environment"

  validation {
    condition     = contains(["view", "edit"], var.developer_role)
    error_message = "Must be one of {view, edit}."
  }
}

variable "k8s_service_endpoints" {
  description = "Indicates the vnet service endpoints to use for the AKS cluster"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to deploy onto"
  type        = list(number)
}

variable "log_analytics_workspace_name" {
  description = "Name of the log analytics workspace that is generated in the base layer"
  type        = string
}


variable "vnet_cidr" {
  description = "CIDR for the base vnet"
  type        = list(string)
}

variable "k8s_default_pool_vm_size" {
  description = "The SKU which should be used for the Virtual Machines used in this Node Pool. Changing this forces a new resource to be created"
  default     = "Standard_D2_v2"
}

variable "k8s_enable_auto_scaling" {
  description = "Whether or not to enable Auto scaling on the cluster nodepool"
  default     = false
}

variable "k8s_node_max_count" {
  description = "The number of nodes which should exist in this Node Pool. During auto scaling, If specified this must be between 1 and 100"
  default     = 3
}

variable "k8s_node_min_count" {
  description = "The number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100"
  default     = 1
}

variable "database_server_name" {
  description = "Name of the database server"
}

variable "secrets_prefix" {
  description = "Prefix for secrets"
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

variable "enable_high_availability" {
  description = "A boolean to determine whether to enable High Availability or not"
  type        = bool
}

variable "database_name" {
  description = "Name of the database"
  type = map(object({
    shortname = string
  }))
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

variable "zone" {
  description = "Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3."
}

variable "service_vault_name" {
  type        = string
  description = "Name of the vault"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id"
}

variable "admins" {
  type        = list(string)
  description = "List of administrators object id"
}

variable "readers" {
  type        = list(string)
  description = "List of readers object id"
}

variable "purge_protection_enabled" {
  description = "Is Purge Protection enabled for this Key Vault?"
  type        = bool
  default     = true
}

variable "service_vault_admins" {
  type        = list(string)
  description = "A list of user/service principal Object IDs that will have admin rights on the **service vault**"
}

variable "disabled_logs" {
  description = "A list of disabled logs"
  type        = list(string)
  default     = []
}

variable "storage_account_name" {
  description = "The storage account name"
}

variable "container_name" {
  description = "The storage container name"
}

variable "replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  type        = string
}

variable "storage_account_readers" {
  type        = list(string)
  description = "A list of user/service principal Object IDs that will have read permissions on the storage account"
}

# helm deploy
variable "ingress_chart_version" {
  type        = string
  description = "HELM Chart Version for nginx-ingress"
  default     = "1.11.0"
}

variable "certmanager_chart_version" {
  type        = string
  description = "HELM Chart Version for cert-manager"
  default     = "1.11.0"
}

variable "cluster_issuer_server" {
  description = "The ACME server URL"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "cluster_issuer_email" {
  description = "Email address used for ACME registration"
  type        = string
}

variable "cluster_issuer_private_key_secret_name" {
  description = "Name of a secret used to store the ACME account private key"
  type        = string
  default     = "cert-manager-private-key"
}

variable "cluster_issuer_name" {
  description = "Cluster Issuer Name, used for annotations"
  type        = string
  default     = "cert-manager"
}

variable "cluster_issuer_create" {
  description = "Create Cluster Issuer"
  type        = bool
  default     = true
}

variable "cluster_issuer_yaml" {
  description = "Create Cluster Issuer with your yaml"
  type        = string
  default     = null
}

variable "additional_set" {
  description = "Additional sets to Helm"
  default     = []
}

variable "solvers" {
  description = "List of Cert manager solvers. For a complex example please look at the Readme"
  type        = any
  default = [{
    http01 = {
      ingress = {
        class = "nginx"
      }
    }
  }]
}


variable "ai_secret_name" {
  description = "Application insights secretname which needs to be created in aks"
  type        = string
}

variable "secret_namespace" {
  description = "Namespace name where secret needs to be created in aks"
  type        = string
}

variable "sa_secret_name" {
  description = "Storage account secretname which needs to be created in aks"
  type        = string
}
