terraform {
  required_version = ">= 1.6.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.140"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

# сеть
module "network" {
  source       = "./modules/network"
  providers = {
    yandex = yandex
  }
  network_name = "notes-network"
}

# роли
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

# хранилище
module "object_storage" {
  source                 = "./modules/object_storage"
  folder_id              = var.yc_folder_id
  bucket_name            = "alm-image-storage-bucket1"
}

 База данных
module "notes_db_cluster" {
  source = "./modules/postgresql"  # путь к модулю
  cluster_name      = "notes-db-cluster"
  network_id        = module.network.vpc_network_id
  private_subnet_id = module.network.private_subnet_id
  user_db_pass      = var.user_db_pass
  postgres_admin_pass    = var.postgres_admin_pass
}

