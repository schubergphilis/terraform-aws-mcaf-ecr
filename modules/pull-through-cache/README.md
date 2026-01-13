# ECR Pull-Through Cache Setup
This module creates cache rule, registry policy and repository creation template for ECR .

Sample creation of a github pull through cache is under examples/github.

```hcl
module "ecr_pull_through_cache" {
  source                            = "../pull-through-cache"
  create_registry_policy            = true
  ecr_creation_template_role_arn    = "arn:aws:iam::123456789012:role/rolename"
  ecr_readonly_principals           = ["1234567890"]
  kms_key_arn                       = "arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  ecr_pull_through_cache_rules = {ecrpub = {
    ecr_repository_prefix = "ecr-public"
    upstream_registry_url = "public.ecr.aws"
    }
  }
}
```

For pull through cache configuration you can use following samples.
```hcl
{
  ecrpub = {
    ecr_repository_prefix = "ecr-public"
    upstream_registry_url = "public.ecr.aws"
  }
  github = {
    ecr_repository_prefix = "github-public"
    upstream_registry_url = "ghcr.io"
    credential_arn        = aws_secretsmanager_secret.github_registry.arn
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

```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_pull_through_cache_rule.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_through_cache_rule) | resource |
| [aws_ecr_registry_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_policy) | resource |
| [aws_ecr_repository_creation_template.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_creation_template) | resource |
| [aws_caller_identity.ecr_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.creation_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Determines whether resources will be created (affects all resources) | `bool` | `true` | no |
| <a name="input_create_registry_policy"></a> [create\_registry\_policy](#input\_create\_registry\_policy) | Determines whether a registry policy will be created | `bool` | `false` | no |
| <a name="input_ecr_creation_template_role_arn"></a> [ecr\_creation\_template\_role\_arn](#input\_ecr\_creation\_template\_role\_arn) | The custom role arn for the creation template | `string` | `null` | no |
| <a name="input_ecr_readonly_principals"></a> [ecr\_readonly\_principals](#input\_ecr\_readonly\_principals) | List of AWS account IDs. Account IDs (12 digits) will be converted to `arn:aws:iam::<account-id>:root`. | `list(string)` | `[]` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The KMS key used for encryption | `string` | `null` | no |
| <a name="input_ecr_pull_through_cache_rules"></a> [registry\_pull\_through\_cache\_rules](#input\_registry\_pull\_through\_cache\_rules) | List of pull through cache rules to create | `map(map(string))` | `{}` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | The resource tags | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_pull_through_cache_rules"></a> [ecr\_pull\_through\_cache\_rules](#output\_ecr\_pull\_through\_cache\_rules) | Map of ECR pull through cache rules created |
| <a name="output_ecr_registry_policy_id"></a> [ecr\_registry\_policy\_id](#output\_ecr\_registry\_policy\_id) | ECR registry policy resource id |
| <a name="output_ecr_repository_creation_templates"></a> [ecr\_repository\_creation\_templates](#output\_ecr\_repository\_creation\_templates) | Map of ECR repository creation templates |

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_pull_through_cache_rule.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_through_cache_rule) | resource |
| [aws_ecr_registry_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_policy) | resource |
| [aws_ecr_repository_creation_template.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_creation_template) | resource |
| [aws_caller_identity.ecr_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.creation_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Determines whether resources will be created (affects all resources) | `bool` | `true` | no |
| <a name="input_create_registry_policy"></a> [create\_registry\_policy](#input\_create\_registry\_policy) | Determines whether a registry policy will be created | `bool` | `false` | no |
| <a name="input_ecr_creation_template_role_arn"></a> [ecr\_creation\_template\_role\_arn](#input\_ecr\_creation\_template\_role\_arn) | The custom role arn for the creation template | `string` | `null` | no |
| <a name="input_ecr_pull_through_cache_rules"></a> [ecr\_pull\_through\_cache\_rules](#input\_ecr\_pull\_through\_cache\_rules) | List of pull through cache rules to create | <pre>map(object({<br/>    prefix       = string<br/>    registry_url = string<br/>    description  = string<br/>  }))</pre> | <pre>{<br/>  "github": {<br/>    "description": "ECR Pull Through Secret ghcr.io",<br/>    "prefix": "github-public",<br/>    "registry_url": "ghcr.io"<br/>  }<br/>}</pre> | no |
| <a name="input_ecr_readonly_principals"></a> [ecr\_readonly\_principals](#input\_ecr\_readonly\_principals) | List of AWS account IDs. Account IDs (12 digits) will be converted to `arn:aws:iam::<account-id>:root`. | `list(string)` | `[]` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The KMS key used for encryption | `string` | `null` | no |
| <a name="input_ecr_pull_through_cache_rules"></a> [ecr\_pull\_through\_cache\_rules](#input\ecr\_pull\_through\_cache\_rules) | List of pull through cache rules to create | <pre>map(object({<br/>    prefix       = string<br/>    registry_url = string<br/>    description  = string<br/>  }))</pre> | <pre>{<br/>  "github": {<br/>    "description": "ECR Pull Through Secret ghcr.io",<br/>    "prefix": "github-public",<br/>    "registry_url": "ghcr.io"<br/>  }<br/>}</pre> | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | The resource tags | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_pull_through_cache_rules"></a> [ecr\_pull\_through\_cache\_rules](#output\_ecr\_pull\_through\_cache\_rules) | Map of ECR pull through cache rules created |
| <a name="output_ecr_registry_policy_id"></a> [ecr\_registry\_policy\_id](#output\_ecr\_registry\_policy\_id) | ECR registry policy resource id |
| <a name="output_ecr_repository_creation_templates"></a> [ecr\_repository\_creation\_templates](#output\_ecr\_repository\_creation\_templates) | Map of ECR repository creation templates |
<!-- END_TF_DOCS -->
