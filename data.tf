data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_kms_key" "key" {
  count = var.kms_key_id != null ? 1 : 0

  key_id = var.kms_key_id
}

data "aws_iam_policy_document" "dlm_role_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["dlm.amazonaws.com"]
    }
  }
}

# See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/snapshot-lifecycle.html#dlm-prerequisites
# For tagging:
# - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/supported-iam-actions-tagging.html#control-tagging
# - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/control-access-with-tags.html
data "aws_iam_policy_document" "dlm" {
  statement {
    sid = "GetResources"
    actions = [
      "ec2:DescribeFastSnapshotRestores",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshotAttribute",
      "ec2:DescribeSnapshots",
      "ec2:DescribeVolumes",
    ]
    resources = ["*"]
  }

  statement {
    sid = "CreateSnapshots"
    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateSnapshots",
    ]
    resources = ["*"]
  }

  statement {
    sid = "CopySnapshots"
    actions = [
      "ec2:CopySnapshot",
    ]
    resources = ["*"]
  }

  statement {
    sid = "ModifySnapshots"
    actions = [
      "ec2:DeleteSnapshot",
      "ec2:DisableFastSnapshotRestores",
      "ec2:EnableFastSnapshotRestores",
      "ec2:ModifySnapshotAttribute",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "CreateTagsOnSnapshots"
    actions   = ["ec2:CreateTags"]
    resources = ["arn:aws:ec2:*::snapshot/*"]
  }

  statement {
    sid = "AwsEventBridge"
    actions = [
      "events:PutRule",
      "events:DeleteRule",
      "events:DescribeRule",
      "events:EnableRule",
      "events:DisableRule",
      "events:ListTargetsByRule",
      "events:PutTargets",
      "events:RemoveTargets",
    ]
    resources = ["arn:aws:events:*:*:rule/AwsDataLifecycleRule.managed-cwe.*"]
  }

  statement {
    sid = "UseKmsKey"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = [data.aws_kms_key.key[0].arn]
  }

  statement {
    sid       = "CreateGrantFromKmsKeyForAwsResources"
    actions   = ["kms:CreateGrant"]
    resources = [data.aws_kms_key.key[0].arn]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = [
        true,
      ]
    }
  }
}
