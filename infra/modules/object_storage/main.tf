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

resource "yandex_storage_bucket_iam_binding" "editor" {
  bucket = yandex_storage_bucket.images.bucket
  role   = "storage.editor"
  members = [
    "serviceAccount:${module.app_server_sa.service_account_id}",
    "serviceAccount:${module.cloud_function_sa.service_account_id}"
  ]
}