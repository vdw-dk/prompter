# app-skeleton

Copy-paste scaffold for a new Spring Boot application on the zoomie-mac k3s cluster.

## Usage

```bash
# 1. Copy to a new app directory
cp -r infrastructure/modules/app-skeleton infrastructure/apps/my-app

# 2. Find all TODO markers
grep -r "TODO" infrastructure/apps/my-app/

# 3. Fill every TODO, delete unused optional blocks

# 4. Validate
cd infrastructure/apps/my-app
terraform init
terraform validate
terraform fmt -recursive
```

## Files

| File | Purpose | Optional |
|---|---|---|
| `backend.tf` | S3 remote state config | No |
| `versions.tf` | Provider requirements and config | No |
| `main.tf` | Calls `app-base`; exposes `local.namespace`, `local.labels`, `local.annotations`, `local.image` | No |
| `variables.tf` | Full variable contract | No |
| `outputs.tf` | Standard app outputs | No |
| `k8s.tf` | Deployment, Service, HPA | No |
| `network.tf` | NetworkPolicy extensions (ingress + egress) | No |
| `ingress.tf` | Kubernetes Ingress + optional Cloudflare CNAME | Ingress is gated on `create_ingress` |
| `database.tf` | DB credentials Secret — delete if app has no DB | Yes |
| `secrets.tf` | App-specific secrets — delete if not needed | Yes |

## Required TODOs

After copying, search for `TODO` and resolve each one:

1. `backend.tf` — replace `{app-name}` in the state key with your app's identifier
2. `main.tf` — set `app_name` default in the `module "base"` call
3. `variables.tf` — set `app_name` and `image_repository` defaults
4. If using Cloudflare DNS: uncomment the cloudflare provider in `versions.tf` and the `cloudflare_record` in `ingress.tf`

## Spring Boot requirements

The skeleton expects Spring Boot Actuator on the classpath so health probes work:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

And in `application.yml`:

```yaml
management:
  endpoint:
    health:
      probes:
        enabled: true
  health:
    livenessState:
      enabled: true
    readinessState:
      enabled: true
```

## Database (optional)

If the app uses Postgres, set these in `terraform.tfvars`:

```hcl
db_host                 = "postgres.db.svc.cluster.local"  # from layer-3 output
db_port                 = 5432
db_name                 = "my_app_db"
db_username             = "my_app_user"
db_password_secret_name = "postgres-my-app-secret"         # created by layer 3
```

The `database.tf` creates a Kubernetes Secret with `SPRING_DATASOURCE_URL` and `SPRING_DATASOURCE_USERNAME`. The password is mounted from `db_password_secret_name` (a pre-existing layer-3 secret) — Terraform never sees the password value.

## Enabling ingress

Once `ingress-nginx` is deployed (layer 1), flip the flag and set the host:

```hcl
create_ingress = true
ingress_host   = "my-app.vdw.dk"
```

## Traceability

In local dev, the traceability variables (`git_commit_sha`, `actions_run_id`, etc.) default to `"local"`. In CI, the deploy workflow passes real values:

```bash
terraform apply \
  -var="git_commit_sha=${GITHUB_SHA}" \
  -var="git_ref=${GITHUB_REF}" \
  -var="git_repository=${GITHUB_REPOSITORY}" \
  -var="actions_run_id=${GITHUB_RUN_ID}" \
  -var="actions_run_url=https://github.com/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}" \
  -var="image_tag=git-${GITHUB_SHA::7}" \
  -var="image_digest=${IMAGE_DIGEST}"
```

## Layer model compliance checklist

Before merging any app module:

- [ ] State key follows `zoomie-mac-vdw/apps/{app-name}/terraform.tfstate`
- [ ] `module "base"` is the first call in `main.tf`
- [ ] All resources use `local.namespace`, `local.labels`, `local.annotations`
- [ ] No `kubernetes_namespace` declared directly in the app root
- [ ] No `helm_release` resources
- [ ] `kubernetes_network_policy` covers both ingress and egress
- [ ] Egress allows DNS (port 53 UDP) — handled by `app-base` baseline
- [ ] No hardcoded domain, issuer name, or ingress class in resource definitions
- [ ] Image tag is a variable, never hardcoded or `latest`
- [ ] `terraform plan -destroy` shows zero impact on layer-3 resources
- [ ] No `TODO` markers remain
