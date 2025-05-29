variable "function_name" {
  type = string
}

variable "service_account_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "storage_access_key" {
  type      = string
  sensitive = true
}

variable "storage_secret_key" {
  type      = string
  sensitive = true
}

variable "max_image_size" {
  type    = string
  default = "5242880" # 5MB
}