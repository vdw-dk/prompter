# TODO: Replace all occurrences of "app-skeleton" with your app name before applying.
#
# Usage:
#   cp -r infrastructure/modules/app-skeleton infrastructure/apps/{app-name}
#   grep -r "TODO" infrastructure/apps/{app-name}/
#   # Fill in every TODO, delete unused optional blocks, run: terraform validate

module "base" {
  # Path assumes this module lives under infrastructure/apps/{app-name}/.
  # Update if placed elsewhere.
  source = "../../modules/app-base"

  # TODO: Set to your app's canonical identifier (lowercase, hyphens only).
  app_name    = var.app_name
  environment = var.environment
  team        = var.team

  image_repository = var.image_repository
  image_tag        = var.image_tag
  image_digest     = var.image_digest

  resource_quota = var.resource_quota

  # Traceability — all resolved from GitHub Actions context by CI pipeline.
  git_commit_sha  = var.git_commit_sha
  git_ref         = var.git_ref
  git_repository  = var.git_repository
  pr_number       = var.pr_number
  actions_run_id  = var.actions_run_id
  actions_run_url = var.actions_run_url
}

locals {
  namespace   = module.base.namespace
  labels      = module.base.labels
  annotations = module.base.annotations
  image       = module.base.image
}
