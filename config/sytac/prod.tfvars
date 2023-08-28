environment         = "prod"
location            = "West Europe"
project             = "sytac"
resource_group_name = ""
subscription_id     = ""
tenant_id           = ""

tags = {
  Application = "Ghost"
  Department  = "R&D"
  Owner       = "Babu Ganesan"
}

#log analytics
log_analytics_workspace_name = "ghost-kkpk"

#vnet & subnet
virtual_network_name = "vnet-ghost"
vnet_cidr            = ["10.51.144.0/20"]
subnets = {
  # Got this range from Infra team through change request
  k8s                = "10.51.144.0/22"
  ingress_controller = "10.51.148.0/28"
  mysqlfs            = "10.51.149.32/28"
}

#acr
container_registries = {
  "acrghost" = {
    AcrPush = []
    AcrPull = []
    Reader  = []
  }
}
container_registry_name = "acrghost"

//keyvault
purge_protection_enabled = false
service_vault_name       = "akv-ghost"

admins = [
  "2a1fd827-47a9-46fb-a3ea-4af561104wedr",
]
service_vault_admins = [
  "2a1fd827-47a9-4623-a3ea-4af561104be2"
]
readers = []

//MySQL Database
database_server_name         = "mysqlfs-ghost"
secrets_prefix               = "ghost-mysqlfs"
enable_high_availability     = false
geo_redundant_backup_enabled = false
database_sku_name            = "B_Standard_B1s"
database_storage             = 20
database_iops                = 360
zone                         = "2"
database_version             = "8.0.21"
database_name = {
  ghost = {
    shortname = "ghostdb",
  }
}

#k8s
kubernetes_cluster_name     = "aks-ghost"
k8s_controlplane_version    = "1.27.3"
k8s_nodepool_version        = "1.27.3"
k8s_cluster_fqdn            = "ghost-k8s-cluster-fqdn"
k8s_enable_managed_identity = true
availability_zones          = [1, 2]
k8s_default_pool_vm_size    = "Standard_DS2_v2"
k8s_enable_auto_scaling     = true
k8s_node_max_count          = 3
k8s_node_min_count          = 1
namespaces = [
  "tools",
  "platform",
  "cert-manager",
]
developer_role         = "view"
enforce_azure_policies = false
k8s_service_endpoints = [
  "Microsoft.Sql",
  "Microsoft.Storage",
]
# Disable by default, only enable for production clusters
k8s_enable_sla = false
aks_admin_group_object_ids = [
  "2a1fd827-47a9-46fb-a3ea-4af561104be2",
]
deployment_service_principal_ids = [
  "2a1fd827-47a9-46fb-a3ea-4af561104be2",
]
aks_reader_group_object_ids = [
  "2a1fd827-47a9-46fb-a3ea-4af561104be2",
]

# storage account
storage_account_name = "saghostfile"
replication_type     = "LRS"
container_name       = "ghostcontentfiles"
storage_account_readers = [
  "2a1fd827-47a9-46fb-a3ea-4af561104be2",
]

#helm release
ingress_chart_version                  = "4.7.1"
certmanager_chart_version              = "v1.12.3"
cluster_issuer_server                  = "https://acme-v02.api.letsencrypt.org/directory"
cluster_issuer_email                   = "test@gmail.com"
cluster_issuer_private_key_secret_name = "letsencrypt-prod"
cluster_issuer_name                    = "letsencrypt-prod"
cluster_issuer_create                  = true

#secrets
secret_namespace = "tools"
ai_secret_name   = "app-insights-secret"
sa_secret_name   = "secret-pv-ghost"
