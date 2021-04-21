resource "kubernetes_persistent_volume" "disk" {
  count = var.replicas

  metadata {
    name = join("-", [var.pv_prefix, count.index])

    annotations = var.kubernetes_annotations
    labels      = var.kubernetes_labels
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.csi_storage_class

    capacity = {
      storage = "${var.disk_size}G"
    }

    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "topology.ebs.csi.aws.com/zone"
            operator = "In"
            values = [
              aws_ebs_volume.disk[count.index].availability_zone
            ]
          }
        }
      }
    }

    persistent_volume_source {
      csi {
        driver        = "ebs.csi.aws.com"
        volume_handle = aws_ebs_volume.disk[count.index].id
        fs_type       = "ext4"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "disk" {
  count = var.replicas

  metadata {
    name = join("-", [var.pv_prefix, count.index])

    annotations = var.kubernetes_annotations
    labels      = var.kubernetes_labels

    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    volume_name  = kubernetes_persistent_volume.disk[count.index].metadata[0].name

    storage_class_name = var.csi_storage_class

    resources {
      requests = {
        storage = "${var.disk_size}G"
      }
    }
  }
}
