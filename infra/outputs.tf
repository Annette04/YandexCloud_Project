output "image_preview_function_url" {
  value = module.image_preview_function.function_url
}

output "load_balancer_ip" {
  description = "Public IP address of the load balancer"
  value       = module.load_balancer.lb_ip
}