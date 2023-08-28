locals {
  labels = {
    managed-by = "terraform"
  }
}

module "aks" {
  source = "../modules/aks"

  kubernetes_cluster_name    = var.kubernetes_cluster_name
  availability_zones         = var.availability_zones
  controlplane_version       = var.k8s_controlplane_version
  nodepool_version           = var.k8s_nodepool_version
  resource_group_name        = var.resource_group_name
  subnet_id                  = azurerm_subnet.k8s_subnet.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  enable_sla                 = var.k8s_enable_sla
  tags                       = var.tags
  enable_managed_identity    = var.k8s_enable_managed_identity
  default_pool_vm_size       = var.k8s_default_pool_vm_size
  enable_auto_scaling        = var.k8s_enable_auto_scaling
  node_max_count             = var.k8s_node_max_count
  node_min_count             = var.k8s_node_min_count
}

resource "azurerm_key_vault_secret" "k8s_cluster_fqdn" {
  name         = var.k8s_cluster_fqdn
  key_vault_id = module.keyvault.id
  value        = module.aks.cluster_fqdn

  depends_on = [module.keyvault]
}

moved {
  from = azurerm_kubernetes_cluster_node_pool.secondary
  to   = module.aks.azurerm_kubernetes_cluster_node_pool.secondary
}

resource "kubernetes_namespace" "namespaces" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.value

    labels = local.labels
  }
}

# This ClusterRole is given to all devs so they can run the `kubectl top pods` command
resource "kubernetes_cluster_role" "read-pod-metrics" {
  metadata {
    name = "gv:pods:metrics:read"
  }

  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods"]
    verbs      = ["list"]
  }
}

resource "kubernetes_role_binding" "read-pod-metrics" {
  for_each = toset(var.namespaces)

  metadata {
    name      = kubernetes_cluster_role.read-pod-metrics.id
    namespace = each.value
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.read-pod-metrics.id
  }

  dynamic "subject" {
    for_each = toset(var.aks_reader_group_object_ids)
    content {
      kind      = "Group"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}
# End of "read-pod-metrics" section

resource "kubernetes_cluster_role_binding" "admin_role_binding" {
  for_each = toset(var.aks_admin_group_object_ids)

  metadata {
    name = "gv:admin:${each.value}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "Group"
    name      = each.value
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "deployment_role_binding" {
  metadata {
    name = "gv:service-principal:deploy"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  dynamic "subject" {
    for_each = toset(var.deployment_service_principal_ids)
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

resource "kubernetes_role_binding" "cluster-read-access" {
  for_each   = toset(local.service_namespaces)
  depends_on = [kubernetes_namespace.namespaces]

  metadata {
    name      = "gv:developer:${var.developer_role}"
    namespace = each.value
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.developer_role
  }

  dynamic "subject" {
    for_each = toset(var.aks_reader_group_object_ids)
    content {
      kind      = "Group"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

# This ClusterRole is given to all devs so they can list namespaces.
resource "kubernetes_cluster_role" "read-namespaces" {
  metadata {
    name = "gv:namespaces:read"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "namespace-list" {
  metadata {
    name = "gv:namespaces:read-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "gv:namespaces:read"
  }

  dynamic "subject" {
    for_each = toset(var.aks_reader_group_object_ids)
    content {
      kind      = "Group"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

# Allow the cluster pull permissions on the container registry
resource "azurerm_role_assignment" "aks_acr" {
  scope                = data.azurerm_container_registry.acr.id
  principal_id         = module.aks.kubelet_identity.0.object_id
  role_definition_name = "AcrPull"

  depends_on = [module.acr, module.aks]
}
