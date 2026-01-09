resource "aws_secretsmanager_secret" "github_registry" {
  #checkov:skip=CKV2_AWS_57: Does not support auto-rotate
  count       = var.create_github_registry_secret ? 1 : 0
  name        = "ecr-pullthroughcache/ghcr.io"
  description = "ECR Pull Through Secret"

  kms_key_id = var.create_ecr_kms ? module.ecr_kms[0].id : null
}

resource "aws_secretsmanager_secret" "gitlab_registry" {
  #checkov:skip=CKV2_AWS_57: Does not support auto-rotate
  count       = var.create_gitlab_registry_secret ? 1 : 0
  name        = "ecr-pullthroughcache/gitlab-registry"
  description = "ECR Pull Through Secret for registry.gitlab.com"

  kms_key_id = var.create_ecr_kms ? module.ecr_kms[0].id : null
}

resource "aws_secretsmanager_secret" "dockerhub_registry" {
  #checkov:skip=CKV2_AWS_57: Does not support auto-rotate
  count       = var.create_dockerhub_registry_secret ? 1 : 0
  name        = "ecr-pullthroughcache/dockerhub-registry"
  description = "ECR Pull Through Secret for Docker Hub"

  kms_key_id = var.create_ecr_kms ? module.ecr_kms[0].id : null
}

module "ecr_kms" {
  count   = var.create_ecr_kms ? 1 : 0
  source  = "schubergphilis/mcaf-kms/aws"
  version = "~> 1.0.0"

  description = "KMS key for ECR repositories"
  name        = "ecr"
  policy      = data.aws_iam_policy_document.ecr_kms_key_policy.json
}

module "ecr_repo_creation_template_role" {
  count   = var.create_ecr_repo_creation_role ? 1 : 0
  source  = "schubergphilis/mcaf-role/aws"
  version = "~> 0.5.3"

  name                  = "EcrRepositoryCreationTemplate"
  create_policy         = true
  permissions_boundary  = var.permissions_boundary != null ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy${var.permissions_boundary}" : null
  postfix               = false
  principal_type        = "Service"
  principal_identifiers = ["ecr.amazonaws.com"]
  role_policy           = data.aws_iam_policy_document.ecr_repo_creation_template.json
}

module "ecr_pull_through_cache" {
  count                             = var.create_pull_through_cache ? 1 : 0
  source                            = "../pull-through-cache"
  create_registry_policy            = true
  ecr_creation_template_role_arn    = length(module.ecr_repo_creation_template_role) > 0 ? module.ecr_repo_creation_template_role[0].arn : null
  ecr_readonly_principals           = var.ecr_readonly_principals
  kms_key_arn                       = var.create_ecr_kms && var.ecr_kms_arn == null ? module.ecr_kms[0].arn : var.ecr_kms_arn
  registry_pull_through_cache_rules = local.registry_pull_through_cache_rules
}
