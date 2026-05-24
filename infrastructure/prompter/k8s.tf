# ── Deployment ────────────────────────────────────────────────────────────────

resource "kubernetes_deployment" "app" {
  metadata {
    name        = var.app_name
    namespace   = local.namespace
    labels      = local.labels
    annotations = local.annotations
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name"     = var.app_name
        "app.kubernetes.io/instance" = "${var.app_name}-${var.environment}"
      }
    }

    template {
      metadata {
        labels      = local.labels
        annotations = local.annotations
      }

      spec {
        service_account_name            = module.base.service_account_name
        automount_service_account_token = false

        container {
          name  = var.app_name
          image = local.image

          port {
            name           = "http"
            container_port = var.container_port
            protocol       = "TCP"
          }

          env {
            name  = "JDK_JAVA_OPTIONS"
            value = var.java_opts
          }

          env {
            name  = "SERVER_PORT"
            value = tostring(var.container_port)
          }

          # Mount DB connection env vars from the secret created in database.tf.
          # This block is skipped (no-op) when db_host is empty.
          dynamic "env_from" {
            for_each = var.db_host != "" ? [1] : []
            content {
              secret_ref {
                name = kubernetes_secret.db_credentials[0].metadata[0].name
              }
            }
          }

          # Mount the DB password from the pre-existing layer-3 secret.
          # This block is skipped when db_password_secret_name is empty.
          dynamic "env_from" {
            for_each = var.db_password_secret_name != "" ? [1] : []
            content {
              secret_ref {
                name = var.db_password_secret_name
              }
            }
          }

          resources {
            requests = {
              cpu    = var.resources.cpu_request
              memory = var.resources.memory_request
            }
            limits = {
              cpu    = var.resources.cpu_limit
              memory = var.resources.memory_limit
            }
          }

          # Spring Boot Actuator liveness endpoint.
          liveness_probe {
            http_get {
              path = var.liveness_probe_path
              port = var.container_port
            }
            initial_delay_seconds = 30
            period_seconds        = 15
            failure_threshold     = 3
            timeout_seconds       = 5
          }

          # Spring Boot Actuator readiness endpoint.
          readiness_probe {
            http_get {
              path = var.readiness_probe_path
              port = var.container_port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            failure_threshold     = 3
            timeout_seconds       = 5
          }
        }

        # Prevent scheduling on nodes with the same app pod already running.
        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"
          label_selector {
            match_labels = {
              "app.kubernetes.io/name" = var.app_name
            }
          }
        }
      }
    }
  }

  lifecycle {
    # Ignore externally-triggered rollouts (e.g. kubectl rollout restart).
    ignore_changes = [spec[0].template[0].metadata[0].annotations["kubectl.kubernetes.io/restartedAt"]]
  }
}

# ── Service ───────────────────────────────────────────────────────────────────

resource "kubernetes_service" "app" {
  metadata {
    name        = var.app_name
    namespace   = local.namespace
    labels      = local.labels
    annotations = local.annotations
  }

  spec {
    selector = {
      "app.kubernetes.io/name"     = var.app_name
      "app.kubernetes.io/instance" = "${var.app_name}-${var.environment}"
    }

    port {
      name        = "http"
      port        = var.container_port
      target_port = var.container_port
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# ── HorizontalPodAutoscaler ───────────────────────────────────────────────────

resource "kubernetes_horizontal_pod_autoscaler_v2" "app" {
  metadata {
    name      = var.app_name
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.app.metadata[0].name
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.hpa_cpu_threshold
        }
      }
    }
  }
}
