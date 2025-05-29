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

resource "yandex_iam_service_account_static_access_key" "sa_keys" {
  service_account_id = var.service_account_id
  description        = "Static access key for object storage"
}