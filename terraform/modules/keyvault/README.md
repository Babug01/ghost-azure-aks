Vault Terraform module
======================

> Terraform module which simplify Azure KeyVault deployment

## Getting started

```hcl
module "vault-acceptance" {
  source = "../../modules/vault"

  name                = "vault-acceptance"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"
  tenant_id           = "${var.azure_tenant_id}"

  admins = [
    "admin1-object-key",
    "admin2-object-key"
  ]

  tags = {
    environment = "acceptance"
    deployed-by = "terraform"
  }
}
```
