variable "network_id" {
  description = "ID сети notes-network"
  type        = string
}

variable "private_subnet_id" {
  description = "ID подсети private_subnet"
  type        = string
}

variable "user_db_pass" {
  type = string
}

variable "postgres_admin_pass" {
  type = string
}

variable "cluster_name" {
  type = string
}