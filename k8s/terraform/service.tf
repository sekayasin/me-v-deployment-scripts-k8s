resource "kubernetes_service" "vof_tracker_service" {
  metadata {
    name            = "${var.deployment_name}"
    namespace       = "${kubernetes_namespace.vof_tracker_namespace.id}"
  }
  
  spec {
    selector {
      app           = "${kubernetes_deployment.vof_tracker_deployment.metadata.0.labels.app}"
    }

    port {
      name          = "http"
      port          = 80
      target_port   = 3000
      protocol      = "TCP"
    }
    type            =   "NodePort"
  }
}
