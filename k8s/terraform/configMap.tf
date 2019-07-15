resource "kubernetes_config_map" "vof_tracker_config" {
  metadata {
    name      = "config"
    namespace = "${kubernetes_namespace.vof_tracker_namespace.id}"
  }

  data {
    PORT                       =  3000
    DB_DUMP                    =  "docker/postgres/dump/*"
    DB_HOST                    =  "${google_sql_database_instance.postgres.public_ip_address}"
    DB_NAME                    =  "${var.database_name}"
    DB_USER                    =  "${var.database_user}"
    RAILS_ENV                  =  "production"
    PGPASSWORD                 =  "${var.pgpassword}"
    RAILS_SERVE_STATIC_FILES   =   true
  }
}
