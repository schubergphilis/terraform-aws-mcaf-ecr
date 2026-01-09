data "aws_caller_identity" "ecr_account" {}

data "aws_region" "current" {}

# ECR Pull through cache - cross account
data "aws_iam_policy_document" "registry" {
  statement {
    actions = [
      "ecr:CreateRepository",
      "ecr:BatchImportUpstreamImage"
    ]
    principals {
      type        = "AWS"
      identifiers = [for k in var.ecr_readonly_principals : "arn:aws:iam::${k}:root"]
    }
    resources = [
      "arn:aws:ecr:${data.aws_region.current.region}:${data.aws_caller_identity.ecr_account.account_id}:repository/*"
    ]
  }
}

data "aws_iam_policy_document" "creation_template" {
  statement {
    sid = "AllowPull"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchImportUpstreamImage"
    ]
    principals {
      type        = "AWS"
      identifiers = [for k in var.ecr_readonly_principals : "arn:aws:iam::${k}:root"]
    }
  }
}
