locals {
  tags = merge(var.tags, {
    Stage = var.tag_environment
  })

  # Container Registry IAM Permissions
  _container_registry_permissions = flatten([
    for name, permissions in var.container_registries : [
      [
        for permission, users in permissions : [
          for user in users : {
            registry   = name
            permission = permission
            user       = user
          }
        ]
      ]
    ]
  ])

  container_registry_permissions = {
    for registry in local._container_registry_permissions : join("-", [registry.registry, registry.permission, registry.user]) => registry
  }
}
