output "kube_admin_config" {
  value = azurerm_kubernetes_cluster.main.kube_admin_config
}

output "kube_admin_config_raw" {
  value = azurerm_kubernetes_cluster.main.kube_admin_config_raw
}

output "id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.main.fqdn
}

output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity
}

output "identities" {
  value = azurerm_kubernetes_cluster.main.identity
}
