# ── NetworkPolicy extensions ──────────────────────────────────────────────────
#
# app-base creates the baseline default-deny (ingress + egress) with DNS open.
# This file adds named extension policies on top.
# Delete blocks that are not needed for this app.

# Allow inbound traffic from the ingress-nginx controller.
resource "kubernetes_network_policy" "allow_ingress_nginx" {
  metadata {
    name      = "${var.app_name}-allow-ingress"
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    pod_selector {}

    policy_types = ["Ingress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "ingress-nginx"
          }
        }
      }
    }
  }
}

# OPTIONAL: Allow egress to Postgres (layer 3).
# Delete this block if the app does not use Postgres.
resource "kubernetes_network_policy" "allow_egress_postgres" {
  count = var.db_host != "" ? 1 : 0

  metadata {
    name      = "${var.app_name}-allow-postgres"
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    pod_selector {}

    policy_types = ["Egress"]

    egress {
      to {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = var.db_namespace
          }
        }
      }

      ports {
        port     = tostring(var.db_port)
        protocol = "TCP"
      }
    }
  }
}

# OPTIONAL: Allow egress to DynamoDB Local (layer 3, namespace zoomie-mac).
# Delete this block if the app does not use DynamoDB Local.
# resource "kubernetes_network_policy" "allow_egress_dynamodb" {
#   metadata {
#     name      = "${var.app_name}-allow-dynamodb"
#     namespace = local.namespace
#     labels    = local.labels
#   }
#
#   spec {
#     pod_selector {}
#     policy_types = ["Egress"]
#     egress {
#       to {
#         namespace_selector {
#           match_labels = { "kubernetes.io/metadata.name" = "zoomie-mac" }
#         }
#       }
#       ports {
#         port     = "8000"
#         protocol = "TCP"
#       }
#     }
#   }
# }

# OPTIONAL: Allow egress to additional declared namespaces.
# Driven by var.egress_allowed_namespaces; add entries via tfvars rather than
# editing this file for common cases.
resource "kubernetes_network_policy" "allow_egress_extra" {
  for_each = toset(var.egress_allowed_namespaces)

  metadata {
    name      = "${var.app_name}-allow-egress-${each.value}"
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    pod_selector {}

    policy_types = ["Egress"]

    egress {
      to {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = each.value
          }
        }
      }
    }
  }
}
