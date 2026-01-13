variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "create_ecr_repo_creation_role" {
  type        = bool
  default     = true
  description = "Create the IAM role used as a template for ECR repository creation (module.ecr_repo_creation_template_role)."
}

variable "create_registry_policy" {
  description = "Determines whether a registry policy will be created"
  type        = bool
  default     = false
}

variable "ecr_creation_template_role_arn" {
  description = "The custom role arn for the creation template"
  type        = string
  default     = null
}

variable "ecr_pull_through_cache_rules" {
  description = "List of pull through cache rules to create"
  type = map(object({
    ecr_repository_prefix = string
    upstream_registry_url = string
    credential_arn        = optional(string)
    description           = string
  }))
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

variable "permissions_boundary" {
  type        = string
  default     = null
  description = "Name of Permissions Boundary, including path. (e.g. /ep/workload_boundary)"
}

variable "resource_tags" {
  description = "The resource tags"
  type        = map(string)
  default     = null
}
