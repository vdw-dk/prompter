# ── Application secrets ───────────────────────────────────────────────────────
#
# OPTIONAL: App-specific secrets not related to databases.
# Delete this file if the app has no additional secrets.
#
# Prefer SealedSecret (via kubeseal) over raw kubernetes_secret for any value
# that originates outside Terraform — the encrypted manifest is safe to commit.
#
# If you need a raw Kubernetes secret from a value that Terraform manages
# (e.g. an API key passed in from CI), use the pattern below. Add a variable
# for the value, mark it sensitive = true, and do not put it in .tfvars files.

# Example: mount an API key as a Kubernetes secret.
#
# resource "kubernetes_secret" "app_api_key" {
#   metadata {
#     name      = "${var.app_name}-api-key"
#     namespace = local.namespace
#     labels    = local.labels
#   }
#   data = {
#     API_KEY = var.api_key
#   }
# }
#
# In k8s.tf Deployment, add to the container block:
#   env_from {
#     secret_ref { name = kubernetes_secret.app_api_key.metadata[0].name }
#   }

# Example: SealedSecret via kubernetes_manifest (requires controller in cluster).
#
# resource "kubernetes_manifest" "app_sealed_secret" {
#   manifest = {
#     apiVersion = "bitnami.com/v1alpha1"
#     kind       = "SealedSecret"
#     metadata   = {
#       name      = "${var.app_name}-secret"
#       namespace = local.namespace
#     }
#     spec = {
#       encryptedData = {
#         # TODO: Replace with output of: kubeseal --raw --from-file=secret.txt --namespace <ns>
#         API_KEY = "AgA..."
#       }
#       template = {
#         metadata = {
#           name      = "${var.app_name}-secret"
#           namespace = local.namespace
#           labels    = local.labels
#         }
#       }
#     }
#   }
# }
