variable "function_name" {
  description = "Name of the Cloud Function"
  type        = string
}

variable "service_account_id" {
  description = "Service Account ID for the function"
  type        = string
}

variable "bucket_name" {
  description = "Name of the Object Storage bucket"
  type        = string
}

variable "storage_access_key" {
  description = "Access key for Object Storage"
  type        = string
  sensitive   = true
}

variable "storage_secret_key" {
  description = "Secret key for Object Storage"
  type        = string
  sensitive   = true
}

variable "max_image_size" {
  description = "Maximum image size in bytes"
  type        = number
  default     = 5242880 # 5MB
}