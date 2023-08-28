# Getting Started

1. Make sure you are pointing to the right subscription:

   ```
   $ az account show
   ```

2. Initialize the backend that you want to target.

   ```
   $ terraform init -backend-config ../../config/_bootstrap/backend.hcl
   ```

3. Plan and apply your changes:
   ```
   $ terraform apply -var-file ../../config/_bootstrap/terraform.tfvars
   ```
