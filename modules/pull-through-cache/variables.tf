variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "create_registry_policy" {
  description = "Determines whether a registry policy will be created"
  type        = bool
  default     = false
}

variable "resource_tags" {
  description = "The resource tags"
  type        = map(string)
  default     = null
}

variable "ecr_creation_template_role_arn" {
  description = "The custom role arn for the creation template"
  type        = string
  default     = null
}

variable "ecr_readonly_principals" {
  type        = list(string)
  default     = []
  description = "List of AWS account IDs. Account IDs (12 digits) will be converted to `arn:aws:iam::<account-id>:root`."
}

variable "kms_key_arn" {
  description = "The KMS key used for encryption"
  type        = string
  default     = null
}

variable "registry_pull_through_cache_rules" {
  description = "List of pull through cache rules to create"
  type = map(object({
    prefix       = string
    registry_url = string
    description  = string
  }))
  default = {
    github = {
      prefix       = "github-public"
      registry_url = "ghcr.io"
      description  = "ECR Pull Through Secret ghcr.io"
    }
  }
}
