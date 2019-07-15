resource "google_compute_network" "vof_tracker_network" {
  name                     = "vof-tracker-${var.environment}-vpc"
  auto_create_subnetworks   = false
}

resource "google_compute_subnetwork" "vof_tracker_subnet" {
  name                          = "vof-tracker-${var.environment}-subnet"
  ip_cidr_range                 = "10.0.0.0/16"
  region                        = "${var.region}"
  network                       = "${google_compute_network.vof_tracker_network.self_link}"
  private_ip_google_access      = true
}
