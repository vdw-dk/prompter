# ── Kubernetes connection ─────────────────────────────────────────────────────

variable "kubeconfig_path" {
  type        = string
  default     = "/Users/hhvdw/.kube/config"
  description = "Path to the kubeconfig file."
}

variable "kubeconfig_context" {
  type        = string
  default     = "k3d-zoomie-mac"
  description = "kubeconfig context to use."
}

# ── App identity ──────────────────────────────────────────────────────────────

variable "app_name" {
  type        = string
  default     = "prompter"
  description = "Canonical app identifier (lowercase, hyphens). Becomes the namespace name."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment: dev, staging, production."
}

variable "team" {
  type        = string
  default     = "homelab"
  description = "Owning team label."
}

# ── Image ─────────────────────────────────────────────────────────────────────

variable "image_repository" {
  type        = string
  default     = "ghcr.io/vdw-dk/prompter/prompter-api"
  description = "Full image repository, e.g. registry.vdw.dk/my-app."
}

variable "image_tag" {
  type        = string
  default     = "local"
  description = "Image tag to deploy. CI passes git-{short-sha}. Never use 'latest'."
}

variable "image_digest" {
  type        = string
  default     = ""
  description = "Image digest (sha256:...). Resolved by CI after docker push. Empty for local dev."
}

# ── Runtime resources ─────────────────────────────────────────────────────────

variable "replicas" {
  type        = number
  default     = 1
  description = "Initial replica count. HPA will scale between min_replicas and max_replicas."
}

variable "min_replicas" {
  type        = number
  default     = 1
  description = "HPA minimum replica count."
}

variable "max_replicas" {
  type        = number
  default     = 3
  description = "HPA maximum replica count."
}

variable "hpa_cpu_threshold" {
  type        = number
  default     = 70
  description = "HPA target CPU utilisation percentage."
}

variable "resource_quota" {
  type = object({
    cpu_requests    = string
    memory_requests = string
    cpu_limits      = string
    memory_limits   = string
  })
  default = {
    cpu_requests    = "500m"
    memory_requests = "512Mi"
    cpu_limits      = "1000m"
    memory_limits   = "1Gi"
  }
  description = "Namespace-level ResourceQuota ceiling."
}

variable "resources" {
  type = object({
    cpu_request    = string
    memory_request = string
    cpu_limit      = string
    memory_limit   = string
  })
  default = {
    cpu_request    = "250m"
    memory_request = "384Mi"
    cpu_limit      = "500m"
    memory_limit   = "768Mi"
  }
  description = "Container resource requests and limits. memory_limit should be ~75% of namespace quota."
}

# ── Spring Boot ───────────────────────────────────────────────────────────────

variable "container_port" {
  type        = number
  default     = 8080
  description = "Port exposed by the Spring Boot container."
}

variable "java_opts" {
  type        = string
  default     = "-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
  description = "JVM options injected via JDK_JAVA_OPTIONS. UseContainerSupport reads cgroup limits."
}

variable "liveness_probe_path" {
  type        = string
  default     = "/actuator/health/liveness"
  description = "Spring Boot Actuator liveness endpoint."
}

variable "readiness_probe_path" {
  type        = string
  default     = "/actuator/health/readiness"
  description = "Spring Boot Actuator readiness endpoint."
}

# ── Networking ────────────────────────────────────────────────────────────────

variable "ingress_host" {
  type        = string
  default     = ""
  description = "Public hostname for this app, e.g. my-app.vdw.dk. Source: resolved per environment."
}

variable "create_ingress" {
  type        = bool
  default     = false
  description = "Create a Kubernetes Ingress resource. Set true once ingress-nginx is deployed."
}

# ── Resolved from layer 1 outputs by CI pipeline ─────────────────────────────

variable "ingress_class_name" {
  type        = string
  default     = "nginx"
  description = "Ingress class name. Source: layer1 output ingress_class_name."
}

variable "cluster_issuer_name" {
  type        = string
  default     = "letsencrypt-prod"
  description = "cert-manager ClusterIssuer name. Source: layer1 output cluster_issuer_name."
}

# ── Cloudflare DNS (optional) ─────────────────────────────────────────────────

variable "create_dns_record" {
  type        = bool
  default     = false
  description = "Create a Cloudflare CNAME record. Requires cloudflare provider and non-empty cloudflare_zone_id."
}

variable "cloudflare_zone_id" {
  type        = string
  default     = ""
  description = "Cloudflare zone ID for vdw.dk. Source: layer1 output cloudflare_zone_id."
}

variable "cname_record" {
  type        = string
  default     = ""
  description = "CNAME subdomain to create in Cloudflare. Leave empty if ingress_host is apex."
}

# ── Resolved from layer 3 outputs by CI (omit block if app has no DB) ─────────

variable "db_host" {
  type        = string
  default     = ""
  description = "Postgres host. Source: layer3/postgres output postgres_host. Empty = no DB."
}

variable "db_port" {
  type        = number
  default     = 5432
  description = "Postgres port. Source: layer3/postgres output postgres_port."
}

variable "db_name" {
  type        = string
  default     = ""
  description = "Database name for this app."
}

variable "db_username" {
  type        = string
  default     = ""
  description = "Database username for this app."
}

variable "db_password_secret_name" {
  type        = string
  default     = ""
  description = "Pre-existing Kubernetes secret name containing the DB password (created by layer 3)."
}

variable "db_namespace" {
  type        = string
  default     = "postgres"
  description = "Namespace where the Postgres cluster runs. Used in egress NetworkPolicy."
}

# ── Egress allowances ─────────────────────────────────────────────────────────

variable "egress_allowed_namespaces" {
  type        = list(string)
  default     = []
  description = "Additional namespaces this app is allowed to reach via egress."
}

variable "egress_allowed_ports" {
  type        = list(number)
  default     = []
  description = "Additional external ports this app is allowed to reach via egress."
}

# ── Traceability — resolved from GitHub Actions context by CI ─────────────────

variable "git_commit_sha" {
  type        = string
  default     = "local"
  description = "Full 40-char Git commit SHA. Source: github.sha. Use 'local' for local dev."
}

variable "git_ref" {
  type        = string
  default     = "refs/heads/local"
  description = "Git ref that triggered the run, e.g. refs/heads/main. Source: github.ref."
}

variable "git_repository" {
  type        = string
  default     = "vdw-dk/prompter"
  description = "Repository in owner/repo format. Source: github.repository."
}

variable "pr_number" {
  type        = string
  default     = ""
  description = "PR number that triggered this deploy. Source: github.event.pull_request.number."
}

variable "actions_run_id" {
  type        = string
  default     = "local"
  description = "GitHub Actions run ID. Source: github.run_id."
}

variable "actions_run_url" {
  type        = string
  default     = "local"
  description = "Direct URL to the Actions run. Source: https://github.com/{repo}/actions/runs/{run_id}."
}
