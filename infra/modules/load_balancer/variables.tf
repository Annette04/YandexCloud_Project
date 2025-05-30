variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "app-load-balancer"
}

variable "region" {
  description = "Yandex Cloud region"
  type        = string
  default     = "ru-central1"
}

variable "health_check_path" {
  description = "Path for health checks"
  type        = string
  default     = "/"
}

variable "target_instances" {
  description = "List of target instances with their subnet IDs and IPs"
  type = list(object({
    subnet_id = string
    address   = string
  }))
}