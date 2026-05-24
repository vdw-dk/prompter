variable "db_name" {
  description = "PostgreSQL database name."
  type        = string
  default     = "prompter"
}

variable "db_username" {
  description = "PostgreSQL username."
  type        = string
  default     = "prompter"
}

variable "db_password" {
  description = "PostgreSQL password. Supply via TF_VAR_db_password — never in a .tfvars file."
  type        = string
  sensitive   = true
}

variable "db_admin_host" {
  description = "Host used by the postgresql provider to connect for provisioning. Expects a port-forward to be active at this address."
  type        = string
  default     = "127.0.0.1"
}

variable "db_admin_port" {
  description = "Port used by the postgresql provider for provisioning."
  type        = number
  default     = 5432
}

variable "db_admin_username" {
  description = "PostgreSQL admin username used to create the app role and database."
  type        = string
}

variable "db_admin_password" {
  description = "PostgreSQL admin password. Supply via TF_VAR_db_admin_password — never in a .tfvars file."
  type        = string
  sensitive   = true
}
