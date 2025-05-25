terraform {
  required_version = ">= 1.6.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.140"
    }
  }
}

module "network" {
  source       = "./modules/network"
  providers = {
    yandex = yandex
  }
  network_name = "notes-network"
}

module "admin_sa" {
  source               = "./modules/iam"
  providers = {
    yandex = yandex
  }
  folder_id            = var.yc_folder_id
  service_account_name = "admin-sa"
  roles                = ["editor"]
}

module "app_server_sa" {
  source               = "./modules/iam"
  providers = {
    yandex = yandex
  }
  folder_id            = var.yc_folder_id
  service_account_name = "app-server-sa"
  roles                = [
    "storage.editor",
    "mdb.admin",
    "serverless.functions.invoker"
  ]
}

module "cloud_function_sa" {
  source               = "./modules/iam"
  providers = {
    yandex = yandex
  }
  folder_id            = var.yc_folder_id
  service_account_name = "cloud-function-sa"
  roles                = [
    "storage.editor"
  ]
}
