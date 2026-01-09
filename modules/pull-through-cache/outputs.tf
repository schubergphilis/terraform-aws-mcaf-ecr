output "ecr_pull_through_cache_rules" {
  description = "Map of ECR pull through cache rules created"
  value = {
    for k, v in aws_ecr_pull_through_cache_rule.default :
    k => {
      id                    = v.id
      ecr_repository_prefix = v.ecr_repository_prefix
      upstream_registry_url = v.upstream_registry_url
      credential_arn        = try(v.credential_arn, null)
    }
  }
}

output "ecr_registry_policy_id" {
  description = "ECR registry policy resource id"
  value       = try(aws_ecr_registry_policy.default[0].id, null)
}

output "ecr_repository_creation_templates" {
  description = "Map of ECR repository creation templates"
  value = {
    for k, v in aws_ecr_repository_creation_template.default :
    k => {
      id                   = v.id
      prefix               = v.prefix
      custom_role_arn      = v.custom_role_arn
      resource_tags        = v.resource_tags
      image_tag_mutability = v.image_tag_mutability
      repository_policy    = v.repository_policy
      applied_for          = v.applied_for
      encryption_type      = v.encryption_configuration[0].encryption_type
      kms_key              = v.encryption_configuration[0].kms_key
    }
  }
}
