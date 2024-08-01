resource "google_compute_network" "client-vpc" {
  project                 = "terraform-gcp-429515"
  auto_create_subnetworks = false
  name                    = "client-vpc"
}

resource "google_compute_subnetwork" "client-pub-sub" {
  name          = "client-pub-sub"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.client-vpc.id
  region        = "us-central1"
}

resource "google_compute_firewall" "ssh-rule" {
  name    = "ssh-rule"
  network = google_compute_network.client-vpc.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["ssh"]
}

resource "google_compute_firewall" "http-rule" {
  name    = "http-rule"
  network = google_compute_network.client-vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["http"]
}