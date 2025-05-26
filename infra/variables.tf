variable "yc_token" {}
variable "yc_cloud_id" {}
variable "yc_folder_id" {}
variable "yc_zone" {
  default = "ru-central1-a"
}
variable "postgres_admin_pass" {
  description = "Пароль для администратора PostgreSQL"
  type        = string
  sensitive   = true
}

variable "user_db_pass" {
  description = "Пароль для пользователя Django"
  type        = string
  sensitive   = true
}