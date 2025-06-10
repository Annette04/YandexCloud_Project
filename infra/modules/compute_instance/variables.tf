variable "folder_id" {}
variable "subnet_id" {}
variable "service_account_id" {}
variable "vm_name" {}
variable "zone" {
  default = "ru-central1-a"
}
variable "ssh_key" {}
variable "image_family" {
  default = "ubuntu-2204-lts"
}
variable "cpu" {
  default = 2
}
variable "memory" {
  default = 4
}
variable "disk_size" {
  default = 20
}
variable "public_ip" {
  default = true
}