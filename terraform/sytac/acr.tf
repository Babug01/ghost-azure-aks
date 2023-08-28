module "acr" {
  source = "../modules/acr"

  container_registries = var.container_registries
  resource_group_name  = var.resource_group_name
  location             = var.location
  environment          = var.environment
  tags                 = var.tags
}
