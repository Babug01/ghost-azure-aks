module "tfstate" {
  source = "../modules/tfstate"

  for_each       = var.storage_accounts
  resource_group = var.resource_group_name
  name           = each.value.shortname
  contributors   = each.value.contributors
  containers     = each.value.containers
  tags           = var.tags
}
