resource "kubernetes_secret" "ai_secret" {
  metadata {
    name      = var.ai_secret_name
    namespace = var.secret_namespace
  }

  data = {
    instrumentation_key = data.azurerm_key_vault_secret.ai_instrumentation_key.value
    connection_string   = data.azurerm_key_vault_secret.ai_connectin_string.value
  }

  type = "Opaque"

  depends_on = [azurerm_application_insights.service-analytics]
}

resource "kubernetes_secret" "sa_secret" {
  metadata {
    name      = var.sa_secret_name
    namespace = var.secret_namespace
  }

  data = {
    azurestorageaccountname = var.storage_account_name
    azurestorageaccountkey  = data.azurerm_key_vault_secret.primary_access_key.value
  }

  type = "Opaque"

  depends_on = [azurerm_application_insights.service-analytics]
}
