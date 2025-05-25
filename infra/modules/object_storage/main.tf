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

# Доступ cloud_function_sa
resource "yandex_resourcemanager_folder_iam_member" "cloud_function_sa_access" {
  for_each = toset(var.cloud_function_sa_roles)

  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${var.cloud_function_sa_id}"
}

# Доступ app_server_sa
resource "yandex_resourcemanager_folder_iam_member" "app_server_sa_access" {
  for_each = toset(var.app_server_sa_roles)

  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${var.app_server_sa_id}"
}
