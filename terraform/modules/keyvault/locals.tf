locals {
  tags = merge(var.tags, {
    Stage = var.tag_environment
  })
}
