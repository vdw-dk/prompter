output "app_name" {
  description = "Canonical app identifier."
  value       = var.app_name
}

output "namespace" {
  description = "Kubernetes namespace where this app is deployed."
  value       = local.namespace
}

output "ingress_host" {
  description = "Public hostname for this app."
  value       = var.ingress_host
}

output "image_deployed" {
  description = "Full image reference that was deployed: {repository}:{tag}@{digest}."
  value       = local.image
}

output "deploy_labels" {
  description = "Standard label map applied to all resources in this app."
  value       = local.labels
}

output "service_name" {
  description = "ClusterIP Service name for use in Ingress backends or other consumers."
  value       = kubernetes_service.app.metadata[0].name
}
