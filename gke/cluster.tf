resource "google_container_cluster" "vof_tracker_cluster" {
  name                    = "vof-tracker-${var.environment}"
  zone                    = "${var.zone}"
  network                 = "${google_compute_network.vof_tracker_network.self_link}"
  subnetwork              = "${google_compute_subnetwork.vof_tracker_subnet.self_link}"
  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "vof_tracker_pool" {
  name          = "vof-tracker-${var.environment}-node-pool"
  zone          = "${var.zone}"
  cluster       = "${google_container_cluster.vof_tracker_cluster.name}"
  node_count    = 2
  

  node_config {
    machine_type        = "${var.machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  autoscaling {
    min_node_count  = 2
    max_node_count  = 5
  }

  management {
    auto_repair     = true
    auto_upgrade    = true
  }

}
