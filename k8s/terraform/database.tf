resource "google_sql_database_instance" "postgres" {
  name = "${var.db_instance_name}"
  database_version = "${var.database_version}"
  project = "${var.project}"
  region  = "${var.region}"

  settings {
    tier = "${var.database_tier}"

    ip_configuration {
      ipv4_enabled = "true"
      authorized_networks = [
        {
          value = "0.0.0.0/0"
          name  = "CLUSTER"
        }
      ]
    }
  }
}

resource "google_sql_database" "vof_tracker_database" {
  name      = "${var.database_name}"
  instance  = "${google_sql_database_instance.postgres.name}"
  project = "${var.project}"
}

resource "google_sql_user" "vof-user" {
  name     = "${var.database_user}"
  project = "${var.project}"
  instance = "${google_sql_database_instance.postgres.name}"
  password = "${var.db_password}"
}
