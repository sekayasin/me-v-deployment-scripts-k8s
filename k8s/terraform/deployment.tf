resource "kubernetes_deployment" "vof_tracker_deployment" {

  metadata {
    name           = "${var.deployment_name}"
    namespace      = "${kubernetes_namespace.vof_tracker_namespace.id}"
    labels {
      app          = "${var.deployment_name}"
    }
  }

  spec {
    replicas       = 2
    selector {
      match_labels {
        app        = "${var.deployment_name}"
      }
    }

    template {
      metadata {
        namespace  = "${kubernetes_namespace.vof_tracker_namespace.id}"
        labels {
          app      = "${var.deployment_name}"
        }
      }

      spec {
      container {
        image      = "${var.vof_tracker_image}"
        name       = "${var.deployment_name}"

        port {
          container_port  = "${var.deployment_port}"
          name            = "http"
        }

        env_from {
          config_map_ref {
            name = "${kubernetes_config_map.vof_tracker_config.metadata.0.name}"
          }
        }
        
        image_pull_policy = "Always"
        
        resources {
          requests {
            cpu           = "1"
            memory        = "1Gi"
          }
          limits {
            cpu           = "2"
            memory        = "2Gi"
          }
        }

        liveness_probe {
          http_get {
            path        = "/"
            port        = 3000
          }
          timeout_seconds        = 30
          period_seconds         =  30
          initial_delay_seconds  = 120
        }
      }
    }
   }
  }
}


