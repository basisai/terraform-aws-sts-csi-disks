variable "replicas" {
  description = "Number of replicas to create"
  type        = number
  default     = 5
}

variable "ebs_volume_name_prefix" {
  description = "Prefix of EBS Volume names"
  type        = string
}

variable "ebs_volume_encryption" {
  description = "Whether the volume is encrypted or not"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "KMS Key ID to encrypt disks"
  type        = string
  default     = null
}

variable "disk_size" {
  description = "Size of EBS Volume in GiB"
  type        = number
  default     = 10
}

variable "ebs_volume_type" {
  description = "Type of EBS Volume"
  default     = "gp3"
}

variable "ebs_volume_tags" {
  description = "Additional tags for EBS volume"
  default = {
    terraform = "true"
  }
}

variable "ebs_disk_zones" {
  description = "List of zones for disks. If not set, will default to the zones in the current region"
  default     = []
  type        = list(string)
}

######################
# Kubernetes Resource
######################
variable "csi_storage_class" {
  description = "Storage Class for PV"
  type        = string
}

variable "pv_prefix" {
  description = "Prefix of PV resources."
  type        = string
}

variable "kubernetes_annotations" {
  description = "Annotations for Kubernetes resources"

  default = {
    "terraform" = "true"
  }
}

variable "kubernetes_labels" {
  description = "Labels for resources"
  default = {
    "app.kubernetes.io/managed-by" = "Terraform"
  }
}

variable "namespace" {
  description = "Namespace for resources"
  type        = string
  default     = "default"
}

######################
# Data Lifecycle Manager
######################
variable "iam_path" {
  description = "IAM path Role"
  type        = string
  default     = "/"
}

variable "dlm_iam_role" {
  description = "Name of IAM Role for Data Lifecycle Manager"
  type        = string
  default     = "PVBackup"
}

variable "dlm_iam_role_description" {
  description = "Description for IAM role of Data Lifecycle Manager"
  type        = string
  default     = "Used by Data Lifecycle Manager to periodically backup EBS volumes"
}

variable "dlm_iam_role_boundary" {
  description = "IAM Role boundary for Data Lifecycle Manager"
  type        = string
  default     = null
}

variable "dlm_iam_role_tag" {
  description = "IAM Role tags"
  default = {
    Name      = "Persistent Volume Backups"
    terraform = "true"
  }
}

variable "dlm_tagged_resources" {
  description = "Tags on resources that DLM is allowed to manage snapshots for"
  type        = map(string)
  default = {
    dlm_snapshot = "enabled"
  }
}

variable "dlm_description" {
  description = "Description for the DLM"
  type        = string
  default     = "Periodically backup PV disks"
}

variable "dlm_tags" {
  description = "Tags for the DLM resource"
  default = {
    Name      = "Persistent Volume Backups"
    terraform = "true"
  }
}

variable "dlm_schedule" {
  description = "DLM Backup Schedule"
  type = list(object({
    name           = string,
    tags_to_add    = map(string),
    interval_hours = number, # 1,2,3,4,6,8,12 or 24 are valid values.
    retain_count   = number,
  }))
  default = [
    {
      name           = "Hourly"
      tags_to_add    = {}
      interval_hours = 1
      retain_count   = 168 # 1 Week
    }
  ]
}
