provider "postgresql" {
  host      = var.db_admin_host
  port      = var.db_admin_port
  username  = var.db_admin_username
  password  = var.db_admin_password
  database  = "postgres"
  sslmode   = "disable"
  superuser = false
}

resource "postgresql_role" "app" {
  name     = var.db_username
  login    = true
  password = var.db_password
}

resource "postgresql_database" "app" {
  name  = var.db_name
  owner = postgresql_role.app.name
}
