locals {
  tags = merge(var.tags, {
    Stage = var.tag_environment
  })

  service_namespaces = [for ns in var.namespaces : ns if ns != "velero" && ns != "cortex-xdr"]

  ingress_load_balancer_ip = cidrhost(var.subnets.ingress_controller, 4) # Internal loadbalancer picks up first ip in subnet (after reserved ips)

  # The production url is the only different endpoint 'main', all other endpoints are to point at 'non-prod'
  subdomain = var.environment == "prod" ? "main" : "non-prod"

  cluster_issuer = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = var.cluster_issuer_name
    }
    spec = {
      acme = {
        # The ACME server URL
        server         = var.cluster_issuer_server
        preferredChain = "ISRG Root X1"
        # Email address used for ACME registration
        email = var.cluster_issuer_email
        # Name of a secret used to store the ACME account private key
        privateKeySecretRef = {
          name = var.cluster_issuer_private_key_secret_name
        }
        # Enable the HTTP-01 challenge provider
        solvers = var.solvers
      }
    }
  }
}
