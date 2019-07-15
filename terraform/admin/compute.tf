resource "google_compute_firewall" "elk_peer_traffic" {
  name    = "${format("%s-elk-peer-firewall", var.project_name)}"
  network = "${module.network.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["${var.elk_source_ranges}"]
}

resource "google_compute_firewall" "elk_public_traffic" {
  name    = "${format("%s-elk-public-firewall", var.project_name)}"
  network = "${module.network.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "redis_traffic" {
  name    = "${format("%s-redis-firewall", var.project_name)}"
  network = "${module.network.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["1025-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${format("%s-redis-server", var.project_name)}"]
}

# Bastion Host
resource "google_compute_instance" "bastion_host" {
  name         = "${format("%s-bastion-host", var.project_name)}"
  machine_type = "${lookup(var.machine_types, "small")}"
  zone         = "${var.zone}"

  tags = ["${format("%s-bastion-host", var.project_name)}"]

  labels { 
        product    = "${var.product_tag}"
        component  = "elk"
        env        = "staging"
        owner      = "${var.owner_tag}"
        maintainer = "${var.maintainer_tag}"
        state      = "in-use"
        }

  boot_disk {
    initialize_params {
      image = "${var.bastion_image}"
    }
  }

  network_interface {
    subnetwork = "${module.network.public_network_name}"

    access_config = {
      # Static IP
      nat_ip = "${var.bastion_host_ip}"
    }
  }

  metadata {
    serviceAccountEmail = "${var.service_account_email}"
    serial-port-enable  = 1
  }

  service_account {
    email  = "${var.service_account_email}"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_firewall" "bastion_host" {
  name    = "${format("%s-bastion-host-firewall", var.project_name)}"
  network = "${module.network.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${format("%s-bastion-host", var.project_name)}"]
}

resource "google_container_cluster" "admin-redis-elk-cluster" {
  name               = "redis-elk-cluster"
  zone               = "europe-west1-b"
  initial_node_count = 2
  network = "${module.network.self_link}"
  subnetwork = "${module.network.public_network_name}"

  master_auth {
    username = "apprenticeshipadmin"
    password = "${var.admin_cluster_master_password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      project_name = "apprenticeship"
      product    = "${var.product_tag}"
      component  = "redis"
      env        = "production"
      owner      = "isaack_ndungu"
      maintainer = "${var.maintainer_tag}"
      state      = "in-use"
    }

    tags = ["apprenticeship", "elk", "redis"]
  }
}
