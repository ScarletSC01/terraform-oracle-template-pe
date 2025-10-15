# Crear VM Oracle para Perú
resource "google_compute_instance" "oracle_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "projects/oracle-linux-cloud/global/images/family/oracle-linux-8"
      size  = 50
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "Instalando Oracle..."
    sudo apt update -y
    sudo apt install -y wget unzip
    echo "Oracle instalado correctamente" > /tmp/oracle_install.log
  EOT

  tags = ["oracle-db-peru"]
}

# Firewall para permitir acceso al puerto Oracle (1521)
resource "google_compute_firewall" "oracle_firewall" {
  name    = "allow-oracle-peru"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["1521"]
  }

  target_tags   = ["oracle-db-peru"]
  source_ranges = ["0.0.0.0/0"]
}
