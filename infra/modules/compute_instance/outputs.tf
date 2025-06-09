output "vm_id" {
  value = yandex_compute_instance.default.id
}

output "external_ip" {
  value = try(yandex_compute_instance.default.network_interface[0].nat_ip_address, "")
}