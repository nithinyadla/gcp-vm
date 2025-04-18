variable "SERVICE_ACCOUNT_KEY" {
  description = "GCP service account key JSON content"
  type        = string
  sensitive   = true
}

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
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }


  network_interface {
    network = "default"
    access_config {}
  }
}
