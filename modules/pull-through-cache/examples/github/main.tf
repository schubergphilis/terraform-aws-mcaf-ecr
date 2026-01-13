resource "aws_secretsmanager_secret" "github_registry" {
  #checkov:skip=CKV2_AWS_57: Does not support auto-rotate
  name        = "ecr-pullthroughcache/ghcr.io"
  description = "ECR Pull Through Secret"
  kms_key_id  = module.ecr_kms.id
}

module "ecr_kms" {
  source      = "schubergphilis/mcaf-kms/aws"
  version     = "~> 1.0.0"
  description = "KMS key for ECR repositories"
  name        = "ecr"
  policy      = data.aws_iam_policy_document.ecr_kms_key_policy.json
}

module "ecr_pull_through_cache" {
  source                         = "../.."
  create_registry_policy         = true
  ecr_creation_template_role_arn = module.ecr_repo_creation_template_role.arn
  ecr_readonly_principals        = ["1234567890"]
  kms_key_arn                    = module.ecr_kms.arn
  ecr_pull_through_cache_rules = { github = {
    ecr_repository_prefix = "github-public"
    upstream_registry_url = "ghcr.io"
    credential_arn        = aws_secretsmanager_secret.github_registry.arn
    description           = "ECR Pull Through Secret ghcr.io"
  } }
}
