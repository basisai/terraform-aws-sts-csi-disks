resource "aws_ebs_volume" "disk" {
  count = var.replicas

  availability_zone = element(coalescelist(var.ebs_disk_zones, data.aws_availability_zones.available.names), count.index)

  size = var.disk_size
  type = var.ebs_volume_type

  encrypted  = var.ebs_volume_encryption
  kms_key_id = var.kms_key_id != null ? data.aws_kms_key.key[0].arn : null

  tags = merge(
    {
      Name = join("-", [var.ebs_volume_name_prefix, count.index])
    },
    var.ebs_volume_tags,
    var.dlm_tagged_resources,
  )
}
