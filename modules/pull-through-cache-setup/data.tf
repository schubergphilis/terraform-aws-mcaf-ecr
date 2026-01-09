data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "ecr_kms_key_policy" {
  statement {
    sid       = "Base Permissions"
    actions   = ["kms:*"]
    effect    = "Allow"
    resources = ["arn:aws:kms:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:key/*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }

  statement {
    sid = "Encrypt and Decrypt permissions for AWS services"
    actions = [
      "kms:CreateGrant",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ListGrants",
      "kms:ReEncrypt*",
      "kms:RevokeGrants"
    ]
    effect    = "Allow"
    resources = ["arn:aws:kms:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:key/*"]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"

      values = [
        "ec2.${data.aws_region.current.region}.amazonaws.com",
        "ecr.${data.aws_region.current.region}.amazonaws.com",
        "eks.${data.aws_region.current.region}.amazonaws.com",
        "secretsmanager.${data.aws_region.current.region}.amazonaws.com",
      ]
    }

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
}

data "aws_iam_policy_document" "ecr_repo_creation_template" {
  statement {
    actions = [
      "kms:CreateGrant",
      "kms:RetireGrant",
      "kms:DescribeKey",
    ]

    resources = ["arn:aws:kms:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:key/*"]
  }
  statement {
    actions = [
      "ecr:CreateRepository",
      "ecr:ReplicateImage",
      "ecr:TagResource",
      "ecr:BatchImportUpstreamImage",
    ]

    resources = ["arn:aws:ecr:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:repository/*"]
  }
}

