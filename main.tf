provider "google" {
  project     = "bilvantisaimlproject"
  region      = "asia-south1"
  zone        = "asia-south1-a"
  credentials = file("service-account-key.json")  # Add this line
}

resource "google_compute_instance" "simple_vm" {
  name         = "simple-vm"
  machine_type = "e2-medium"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}  # This gives the VM a temporary public IP
  }
}

output "vm_public_ip" {
  value = google_compute_instance.simple_vm.network_interface[0].access_config[0].nat_ip
}
