variable "folder_id" {
  description = "ID папки Yandex Cloud"
  type        = string
}

variable "service_account_name" {
  description = "Имя сервисного аккаунта"
  type        = string
}

variable "roles" {
  description = "Список ролей для сервисного аккаунта"
  type        = list(string)
}
