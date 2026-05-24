# ── Ingress ───────────────────────────────────────────────────────────────────
#
# Guarded by var.create_ingress (default false) until ingress-nginx is deployed
# in this cluster. Set create_ingress = true and ingress_host = "my-app.vdw.dk"
# in tfvars once the ingress controller is running.

resource "kubernetes_ingress_v1" "app" {
  count = var.create_ingress ? 1 : 0

  metadata {
    name      = var.app_name
    namespace = local.namespace
    labels    = local.labels

    annotations = merge(local.annotations, {
      "cert-manager.io/cluster-issuer"           = var.cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    })
  }

  spec {
    ingress_class_name = var.ingress_class_name

    tls {
      hosts       = [var.ingress_host]
      secret_name = "${var.app_name}-tls"
    }

    rule {
      host = var.ingress_host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.app.metadata[0].name
              port {
                number = var.container_port
              }
            }
          }
        }
      }
    }
  }
}

# OPTIONAL: Cloudflare CNAME record.
# Uncomment, add the cloudflare provider to versions.tf, and set create_dns_record = true.
#
# resource "cloudflare_record" "app" {
#   count = var.create_dns_record && var.cloudflare_zone_id != "" ? 1 : 0
#
#   zone_id = var.cloudflare_zone_id
#   name    = var.cname_record != "" ? var.cname_record : var.app_name
#   type    = "CNAME"
#   value   = var.ingress_host
#   proxied = true
# }
