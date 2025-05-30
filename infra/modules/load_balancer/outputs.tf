output "lb_id" {
  description = "ID of the load balancer"
  value       = yandex_lb_network_load_balancer.main.id
}

output "lb_ip" {
  description = "External IP address of the load balancer"
  value       = yandex_lb_network_load_balancer.main.listener[*].external_address_spec[*].address
}

output "target_group_id" {
  description = "ID of the target group"
  value       = yandex_lb_target_group.app.id
}