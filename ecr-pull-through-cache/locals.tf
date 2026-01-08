locals {
  registry_pull_through_cache_rules = {
    ecrpub = {
      ecr_repository_prefix = "ecr-public"
      upstream_registry_url = "public.ecr.aws"
    }
    github = {
      ecr_repository_prefix = "github-public"
      upstream_registry_url = "ghcr.io"
      credential_arn        = var.create_github_registry_secret ? aws_secretsmanager_secret.github_registry[0].arn : null
    }
    k8s = {
      ecr_repository_prefix = "k8s-public"
      upstream_registry_url = "registry.k8s.io"
    }
    quay = {
      ecr_repository_prefix = "quay-public"
      upstream_registry_url = "quay.io"
    }
  }
}
