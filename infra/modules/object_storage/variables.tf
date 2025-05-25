variable "folder_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "cloud_function_sa_id" {
  type = string
}

variable "app_server_sa_id" {
  type = string
}

variable "cloud_function_sa_roles" {
  type    = list(string)
  default = ["storage.editor"]
}

variable "app_server_sa_roles" {
  type    = list(string)
  default = ["storage.editor"]
}
