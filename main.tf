provider "google" {
  project     = "bilvantisaimlproject"
  region      = "asia-south1"
  zone        = "asia-south1-a"
  credentials = var.SERVICE_ACCOUNT_KEY
}


resource "google_compute_instance" "vm_instance" {
  name         = "nithin-free-tier-vm"
  machine_type = "f1-micro"
  project      = "bilvantisaimlproject"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
