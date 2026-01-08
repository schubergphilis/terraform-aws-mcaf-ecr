variable "ecr_readonly_principals" {
  type        = list(string)
  default     = []
  description = "Principal Account IDs to provide with readonly access to the ECR"
}

variable "permissions_boundary" {
  type        = string
  default     = null
  description = "Name of Permissions Boundary, including path. (e.g. /ep/workload_boundary)"
}

variable "create_ecr_kms" {
  type        = bool
  default     = true
  description = "Create the KMS key used by ECR and Secrets Manager. Set to false if you will supply an external key and pass its ARN to nested modules."
}

variable "ecr_kms_arn" {
  type        = string
  default     = null
  description = "KMS key ARN that created externally. create_ecr_kms needs to be false to use this key."
}

variable "create_ecr_repo_creation_role" {
  type        = bool
  default     = true
  description = "Create the IAM role used as a template for ECR repository creation (module.ecr_repo_creation_template_role)."
}

variable "create_github_registry_secret" {
  type        = bool
  default     = true
  description = "Create an AWS Secrets Manager secret for GitHub Container Registry credentials (aws_secretsmanager_secret.github_registry). Enabled by default."
}

variable "create_gitlab_registry_secret" {
  type        = bool
  default     = false
  description = "Create an AWS Secrets Manager secret for GitLab registry credentials. Disabled by default."
}

variable "create_dockerhub_registry_secret" {
  type        = bool
  default     = false
  description = "Create an AWS Secrets Manager secret for Docker Hub registry credentials. Disabled by default."
}

variable "create_pull_through_cache" {
  type        = bool
  default     = true
  description = "Create the nested pull-through-cache resources (module.ecr_pull_through_cache). Set false to skip creating repositories/policies."
}
