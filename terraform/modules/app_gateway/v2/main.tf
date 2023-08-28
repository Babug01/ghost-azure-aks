locals {
  certificate_name               = "agw-${var.prefix}-SSL"
  frontend_port_name             = "gw-feport-${var.prefix}"
  frontend_ip_configuration_name = "gw-feip-${var.prefix}"
  name                           = "agw-${var.prefix}-${random_string.name.result}"
}

resource "random_string" "name" {
  length  = 4
  numeric = false
  upper   = false
  special = false
}

resource "azurerm_application_gateway" "main" {
  name                = local.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  zones               = var.availability_zones
  enable_http2        = var.agw_enable_http2

  sku {
    name = var.agw_sku_name
    tier = var.agw_sku_tier
  }

  autoscale_configuration {
    min_capacity = 0
    max_capacity = var.max_capacity
  }

  gateway_ip_configuration {
    name      = "GwPublicFrontendIp"
    subnet_id = azurerm_subnet.frontend.id
  }

  ssl_certificate {
    name = local.certificate_name
    data = var.public_certificate
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.main.id
  }

  # Add: Strict-Transport-Security https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security#preloading_strict_transport_security
  # Delete: Server
  rewrite_rule_set {
    name = "security-headers"

    rewrite_rule {
      name          = "Delete Server Header"
      rule_sequence = 1

      response_header_configuration {
        header_name  = "Server"
        header_value = "" # Set to empty to delete
      }

      response_header_configuration {
        header_name  = "Strict-Transport-Security"
        header_value = "max-age=63072000"
      }
    }
  }

  # Notes:
  # -  The amount of backends is dynamic. We can have:
  #    - web backend
  #    - API backend
  # -  Each backend must have a probe for checking the health status...
  # -  Each backend can have a set of http listeners and request routing rules
  dynamic "backend_address_pool" {
    for_each = var.backends
    content {
      name  = "${backend_address_pool.value.name}-pool"
      fqdns = backend_address_pool.value.fqdns
    }
  }

  dynamic "probe" {
    for_each = var.backends
    content {
      name                                      = "${probe.value.name}-probe"
      pick_host_name_from_backend_http_settings = false
      interval                                  = 30
      timeout                                   = 30
      host                                      = probe.value.probe_host
      path                                      = probe.value.probe_path
      protocol                                  = probe.value.protocol
      unhealthy_threshold                       = 5
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backends
    content {
      name                                = "${backend_http_settings.value.name}-setting"
      cookie_based_affinity               = "Disabled"
      port                                = backend_http_settings.value.protocol == "Https" ? 443 : 80
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = 45
      probe_name                          = "${backend_http_settings.value.name}-probe"
      pick_host_name_from_backend_address = false
      host_name                           = backend_http_settings.value.host_name
    }
  }

  dynamic "http_listener" {
    for_each = var.applications
    content {
      name                           = "${http_listener.value.name}-listener"
      host_name                      = http_listener.value.hostname
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      ssl_certificate_name           = local.certificate_name
      require_sni                    = http_listener.value.require_sni
      protocol                       = "Https"
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.applications
    content {
      name                       = "${request_routing_rule.value.name}-rule"
      http_listener_name         = "${request_routing_rule.value.name}-listener"   # This field is a reference to the name of the http_listener that we setup in the previous block
      backend_http_settings_name = "${request_routing_rule.value.backend}-setting" # This field is a reference ot the name of the backend_http_settings that we setup in the previous block
      backend_address_pool_name  = "${request_routing_rule.value.backend}-pool"    # This field is a reference to the backend_address_pool that contains this service
      rewrite_rule_set_name      = "security-headers"                              # This field is a reference to the rewrite_rule_set that is managing security headers for all traffic
      rule_type                  = "Basic"
      priority                   = (index(var.applications, request_routing_rule.value) + 1) * 10 # This will produce priorities in the following sequence: 10,20,30 etc.
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
