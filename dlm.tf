resource "aws_iam_role" "dlm" {
  description = var.dlm_iam_role_description
  name        = var.dlm_iam_role
  path        = var.iam_path
  tags        = var.dlm_iam_role_tag

  permissions_boundary = var.dlm_iam_role_boundary

  assume_role_policy = data.aws_iam_policy_document.dlm_role_trust_policy.json
}

resource "aws_iam_role_policy" "dlm" {
  name_prefix = "dlm"
  role        = aws_iam_role.dlm.name
  policy      = data.aws_iam_policy_document.dlm.json
}

resource "aws_dlm_lifecycle_policy" "backup" {
  depends_on = [aws_iam_role_policy.dlm]

  description        = var.dlm_description
  execution_role_arn = aws_iam_role.dlm.arn
  tags               = var.dlm_tags

  policy_details {
    resource_types = ["VOLUME"]
    target_tags    = var.dlm_tagged_resources

    dynamic "schedule" {
      for_each = var.dlm_schedule

      content {
        name        = schedule.value.name
        copy_tags   = true
        tags_to_add = schedule.value.tags_to_add

        create_rule {
          interval      = schedule.value.interval_hours
          interval_unit = "HOURS"
          times         = ["00:00"]
        }

        retain_rule {
          count = schedule.value.retain_count
        }
      }
    }
  }
}
