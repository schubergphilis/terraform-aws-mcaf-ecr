resource "aws_ecr_pull_through_cache_rule" "default" {
  for_each = { for k, v in var.registry_pull_through_cache_rules : k => v if var.create }

  ecr_repository_prefix = each.value.ecr_repository_prefix
  upstream_registry_url = each.value.upstream_registry_url
  credential_arn        = try(each.value.credential_arn, null)
}

resource "aws_ecr_registry_policy" "default" {
  count = var.create && var.create_registry_policy ? 1 : 0

  policy = data.aws_iam_policy_document.registry.json
}

resource "aws_ecr_repository_creation_template" "default" {
  for_each = { for k, v in var.registry_pull_through_cache_rules : k => v if var.create }

  custom_role_arn      = var.ecr_creation_template_role_arn
  image_tag_mutability = "IMMUTABLE"
  prefix               = each.value.ecr_repository_prefix
  repository_policy    = data.aws_iam_policy_document.creation_template.json
  resource_tags        = var.resource_tags

  applied_for = [
    "PULL_THROUGH_CACHE",
  ]

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }
}
