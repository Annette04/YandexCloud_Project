terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_storage_bucket" "images" {
  bucket = var.bucket_name
  folder_id = var.folder_id
  acl    = "private"
}