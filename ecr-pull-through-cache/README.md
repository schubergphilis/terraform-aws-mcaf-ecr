# ECR Pull-Through Cache Setup

This Terraform module bootstraps resources used to create ECR pull-through caches for public registries (for example `ghcr.io`, `quay.io`, `registry.k8s.io`, `public.ecr.aws`, etc.). It wires together:

- a KMS key (via `module.ecr_kms`) for encrypting secrets and ECR-related resources,
- a role used as a template for ECR repository creation (`module.ecr_repo_creation_template_role`),
- optional AWS Secrets Manager secrets for upstream registries (example: GitHub Container Registry credential),
- the nested `modules/ecr-pull-through-cache` module which provisions the actual ECR repositories, repository policies and pull-through configuration.

This module is intended to run once in the account that will host the ECR pull-through caches (typically an "upstream" or infrastructure account).

> [!NOTE] 
> In order to use authentication for Github, Gitlab or Docker.io, you need to **fill the following secrets manually** after you ran this module:
> - `ecr-pullthroughcache/ghcr.io`
> - `ecr-pullthroughcache/gitlab-registry`
> - `ecr-pullthroughcache/dockerhub-registry`

Quick view of what gets created

- `aws_kms_key` (via `module.ecr_kms`) — used for Secrets Manager and ECR encryption.
- `aws_secretsmanager_secret` (optional) — for registry credentials (e.g. `ecr-pullthroughcache/ghcr.io`).
- `aws_iam_role` (via `module.ecr_repo_creation_template_role`) — role with permissions to create ECR repositories, used as a template/assumption role by the nested module.
- ECR repositories / policies and pull-through configuration (created by `modules/ecr-pull-through-cache`).

## Usage

As a top-level module call (example):

```hcl
module "ecr_pull_through_cache_setup" {
  source = "./terraform/modules/ecr-pull-through-cache-setup"

  # Optionally grant a list of principals (IAM ARNs) read-only access to the created ECR repositories
  ecr_principals_readonly_access = [
    "arn:aws:iam::111122223333:role/ExampleReadOnlyRole"
  ]

  # Optional permissions boundary path/name to apply to created roles
  # permissions_boundary = "/ep/workload_boundary"
}
```

## Registry configuration

- Registry rules are defined in `locals.tf` as `registry_pull_through_cache_rules`. Each entry should contain:
  - `ecr_repository_prefix` — prefix for created ECR repository names (e.g. `github-public`).
  - `upstream_registry_url` — upstream registry hostname (e.g. `ghcr.io`).
  - `credential_arn` — optional ARN of a SecretsManager secret containing credentials to access the upstream registry. If the upstream registry requires auth (e.g. GHCR private packages), create a Secrets Manager secret and set the `credential_arn` in `locals.tf` (or pass in/override the locals in your own wrapper).

The module ships with examples for several registries in `locals.tf`:

- `ecrpub` (public ECR)
- `github` (GHCR)
- `k8s` (registry.k8s.io)
- `quay` (quay.io)

For Dockerhub and Gitlab you can add following config to `locals.tf`'s `registry_pull_through_cache_rules` map.

```hcl
dockerhub = {
  ecr_repository_prefix = "docker-hub-public"
  upstream_registry_url = "registry-1.docker.io"
  credential_arn        = var.create_dockerhub_registry_secret ? aws_secretsmanager_secret.dockerhub_registry[0].arn : null
}
gitlab = {
  ecr_repository_prefix = "gitlab-public"
  upstream_registry_url = "registry.gitlab.com"
  credential_arn        = var.create_gitlab_registry_secret ? aws_secretsmanager_secret.gitlab_registry[0].arn : null
}
``` 


If you need additional registries, add or modify entries in `locals.tf`'s `registry_pull_through_cache_rules` map or provide your own map into the nested module.


### Troubleshooting

- If upstream registry access fails, confirm that:
  - The Secrets Manager secret (if used) contains valid credentials.
  - The KMS key policies allow the necessary AWS services (ECR, SecretsManager, EKS if applicable) to use the key. The data policy in `data.tf` contains the expected `kms:ViaService` entries.
- To modify which registries are created, update the `registry_pull_through_cache_rules` in `locals.tf` or override the nested module input.
- Inspect the nested module logs/terraform plan to see which repositories and policies will be created before applying.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.27.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr_kms"></a> [ecr\_kms](#module\_ecr\_kms) | schubergphilis/mcaf-kms/aws | ~> 1.0.0 |
| <a name="module_ecr_pull_through_cache"></a> [ecr\_pull\_through\_cache](#module\_ecr\_pull\_through\_cache) | ./modules/ecr-pull-through-cache | n/a |
| <a name="module_ecr_repo_creation_template_role"></a> [ecr\_repo\_creation\_template\_role](#module\_ecr\_repo\_creation\_template\_role) | schubergphilis/mcaf-role/aws | ~> 0.5.3 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.dockerhub_registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.github_registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.gitlab_registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecr_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecr_repo_creation_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_dockerhub_registry_secret"></a> [create\_dockerhub\_registry\_secret](#input\_create\_dockerhub\_registry\_secret) | Create an AWS Secrets Manager secret for Docker Hub registry credentials. Disabled by default. | `bool` | `false` | no |
| <a name="input_create_ecr_kms"></a> [create\_ecr\_kms](#input\_create\_ecr\_kms) | Create the KMS key used by ECR and Secrets Manager. Set to false if you will supply an external key and pass its ARN to nested modules. | `bool` | `true` | no |
| <a name="input_create_ecr_repo_creation_role"></a> [create\_ecr\_repo\_creation\_role](#input\_create\_ecr\_repo\_creation\_role) | Create the IAM role used as a template for ECR repository creation (module.ecr\_repo\_creation\_template\_role). | `bool` | `true` | no |
| <a name="input_create_github_registry_secret"></a> [create\_github\_registry\_secret](#input\_create\_github\_registry\_secret) | Create an AWS Secrets Manager secret for GitHub Container Registry credentials (aws\_secretsmanager\_secret.github\_registry). Enabled by default. | `bool` | `true` | no |
| <a name="input_create_gitlab_registry_secret"></a> [create\_gitlab\_registry\_secret](#input\_create\_gitlab\_registry\_secret) | Create an AWS Secrets Manager secret for GitLab registry credentials. Disabled by default. | `bool` | `false` | no |
| <a name="input_create_pull_through_cache"></a> [create\_pull\_through\_cache](#input\_create\_pull\_through\_cache) | Create the nested pull-through-cache resources (module.ecr\_pull\_through\_cache). Set false to skip creating repositories/policies. | `bool` | `true` | no |
| <a name="input_ecr_kms_arn"></a> [ecr\_kms\_arn](#input\_ecr\_kms\_arn) | KMS key ARN that created externally. create\_ecr\_kms needs to be false to use this key. | `string` | `null` | no |
| <a name="input_ecr_readonly_principals"></a> [ecr\_readonly\_principals](#input\_ecr\_readonly\_principals) | Principal Account IDs to provide with readonly access to the ECR | `list(string)` | `[]` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | Name of Permissions Boundary, including path. (e.g. /ep/workload\_boundary) | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
