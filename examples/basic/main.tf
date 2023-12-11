provider "aws" {
  region = "eu-west-1"
}

module "ecr" {
  source = "../.."

  repository_names = ["image-x", "namespace/image-y"]

  additional_ecr_policy_statements = {
    lambda = {
      effect = "Allow"

      principal = {
        type        = "service"
        identifiers = ["lambda.amazonaws.com"]
      }

      actions = [
        "ecr:BatchGetImage",
        "ecr:DeleteRepositoryPolicy",
        "ecr:GetDownloadUrlForLayerecr:GetRepositoryPolicy",
        "ecr:SetRepositoryPolicy"
      ]

      condition = [
        {
          test     = "StringEquals"
          values   = ["1111111111111"]
          variable = "aws:PrincipalAccount"
        }
      ]
    }
  }
}
