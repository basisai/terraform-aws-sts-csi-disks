# AWS STS CSI Disks

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | ~> 3.28 |
| kubernetes | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.28 |
| kubernetes | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| csi\_storage\_class | Storage Class for PV | `string` | n/a | yes |
| disk\_size | Size of EBS Volume in GiB | `number` | `10` | no |
| dlm\_description | Description for the DLM | `string` | `"Periodically backup PV disks"` | no |
| dlm\_iam\_role | Name of IAM Role for Data Lifecycle Manager | `string` | `"PVBackup"` | no |
| dlm\_iam\_role\_boundary | IAM Role boundary for Data Lifecycle Manager | `string` | `null` | no |
| dlm\_iam\_role\_description | Description for IAM role of Data Lifecycle Manager | `string` | `"Used by Data Lifecycle Manager to periodically backup EBS volumes"` | no |
| dlm\_iam\_role\_tag | IAM Role tags | `map` | <pre>{<br>  "Name": "Persistent Volume Backups",<br>  "terraform": "true"<br>}</pre> | no |
| dlm\_schedule | DLM Backup Schedule | <pre>list(object({<br>    name           = string,<br>    tags_to_add    = map(string),<br>    interval_hours = number, # 1,2,3,4,6,8,12 or 24 are valid values.<br>    retain_count   = number,<br>  }))</pre> | <pre>[<br>  {<br>    "interval_hours": 1,<br>    "name": "Hourly",<br>    "retain_count": 168,<br>    "tags_to_add": {}<br>  }<br>]</pre> | no |
| dlm\_tagged\_resources | Tags on resources that DLM is allowed to manage snapshots for | `map(string)` | <pre>{<br>  "dlm_snapshot": "enabled"<br>}</pre> | no |
| dlm\_tags | Tags for the DLM resource | `map` | <pre>{<br>  "Name": "Persistent Volume Backups",<br>  "terraform": "true"<br>}</pre> | no |
| ebs\_disk\_zones | List of zones for disks. If not set, will default to the zones in the current region | `list(string)` | `[]` | no |
| ebs\_volume\_encryption | Whether the volume is encrypted or not | `bool` | `false` | no |
| ebs\_volume\_name\_prefix | Prefix of EBS Volume names | `string` | n/a | yes |
| ebs\_volume\_tags | Additional tags for EBS volume | `map` | <pre>{<br>  "terraform": "true"<br>}</pre> | no |
| ebs\_volume\_type | Type of EBS Volume | `string` | `"gp3"` | no |
| iam\_path | IAM path Role | `string` | `"/"` | no |
| kms\_key\_id | KMS Key ID to encrypt disks | `string` | `null` | no |
| kubernetes\_annotations | Annotations for Kubernetes resources | `map` | <pre>{<br>  "terraform": "true"<br>}</pre> | no |
| kubernetes\_labels | Labels for resources | `map` | <pre>{<br>  "app.kubernetes.io/managed-by": "Terraform"<br>}</pre> | no |
| namespace | Namespace for resources | `string` | `"default"` | no |
| pv\_prefix | Prefix of PV resources. | `string` | n/a | yes |
| replicas | Number of replicas to create | `number` | `5` | no |

## Outputs

No output.
