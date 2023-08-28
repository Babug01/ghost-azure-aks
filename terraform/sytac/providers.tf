terraform {
  required_version = ">= 1.2.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.0"
    }
  }

  backend "azurerm" {
    # Configured via CLI
  }
}

provider "azurerm" {
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = false # Do not purge vaults/secrets/certs when deleting them.
    }
  }
}

provider "kubernetes" {
  host                   = module.aks.kube_admin_config.0.host
  client_certificate     = base64decode(module.aks.kube_admin_config.0.client_certificate)
  client_key             = base64decode(module.aks.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_admin_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.aks.kube_admin_config.0.host
    client_certificate     = base64decode(module.aks.kube_admin_config.0.client_certificate)
    client_key             = base64decode(module.aks.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(module.aks.kube_admin_config.0.cluster_ca_certificate)
  }
}
