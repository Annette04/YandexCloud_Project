terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_iam_service_account" "this" {
  name = var.service_account_name
}

resource "yandex_resourcemanager_folder_iam_member" "roles" {
  for_each = toset(var.roles)
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.this.id}"
}
