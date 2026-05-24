# ── Database credentials ──────────────────────────────────────────────────────
#
# OPTIONAL: Mount Postgres connection details into the Deployment as environment
# variables. Delete this file entirely if the app does not use a database, and
# remove the db_* variable declarations from variables.tf.
#
# Requires: var.db_host, var.db_name, var.db_username (non-empty).
# The DB password is never stored here — it is read from a pre-existing secret
# created by the layer-3 Postgres module (var.db_password_secret_name).
#
# Spring Boot reads these env vars via application.yml:
#   spring.datasource.url:      ${SPRING_DATASOURCE_URL}
#   spring.datasource.username: ${SPRING_DATASOURCE_USERNAME}

resource "kubernetes_secret" "db_credentials" {
  count = var.db_host != "" ? 1 : 0

  metadata {
    name      = "${var.app_name}-db-credentials"
    namespace = local.namespace
    labels    = local.labels
  }

  # type = "Opaque" is the default for non-TLS secrets.

  data = {
    SPRING_DATASOURCE_URL      = "jdbc:postgresql://${var.db_host}:${var.db_port}/${var.db_name}"
    SPRING_DATASOURCE_USERNAME = var.db_username
    # Password is sourced from var.db_password_secret_name (layer-3 secret).
    # It is mounted in k8s.tf via a separate env_from.secretRef block.
  }
}
