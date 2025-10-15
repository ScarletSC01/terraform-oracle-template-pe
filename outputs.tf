output "oracle_instance_ip" {
  value = google_compute_instance.oracle_instance.network_interface[0].access_config[0].nat_ip
}

output "oracle_instance_name" {
  value = google_compute_instance.oracle_instance.name
}

output "oracle_machine_type" {
  value = google_compute_instance.oracle_instance.machine_type
}

output "oracle_zone" {
  value = google_compute_instance.oracle_instance.zone
}

