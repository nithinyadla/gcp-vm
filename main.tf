provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  credentials = file(var.gcp_credentials)
}

resource "google_compute_instance" "default" {
  name         = "terraform-vm"
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts" 
    }
  }
  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
}

variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
  default     = "bilvantisaimlproject"
}

variable "gcp_region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}

variable "gcp_zone" {
  description = "GCP Zone"
  type        = string
  default     = "asia-south1-a"
}

variable "machine_type" {
  description = "Machine type"
  type        = string
  default     = "e2-medium"
}

variable "gcp_credentials" {
  description = "Path to GCP credentials file"
  type        = string
}

output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
