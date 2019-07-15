resource "kubernetes_namespace" "vof_tracker_namespace" {
  metadata {
    name = "${var.namespace}"
  }
}
