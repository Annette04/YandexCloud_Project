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
  roles                = [
    "editor",
    "mdb.admin",
    "serverless.functions.admin",
  ]
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
    "logging.writer"
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
    "storage.editor",
    "serverless.functions.invoker",
    "logging.writer"
  ]
}

# хранилище
module "object_storage" {
  source                 = "./modules/object_storage"
  folder_id              = var.yc_folder_id
  bucket_name            = "alm-image-storage-bucket1"
  service_account_id = module.cloud_function_sa.service_account_id
}

module "image_preview_function" {
  source             = "./modules/cloud_functions"
  function_name      = "image-preview"
  service_account_id = module.cloud_function_sa.service_account_id
  bucket_name        = module.object_storage.bucket_name
  storage_access_key = module.object_storage.access_key
  storage_secret_key = module.object_storage.secret_key
  max_image_size     = 10485760 # 10MB

  depends_on = [
    module.object_storage,
    module.cloud_function_sa
  ]
}
# База данных
module "notes_db_cluster" {
  source = "./modules/postgresql"  # путь к модулю
  cluster_name      = "notes-db-cluster"
  network_id        = module.network.vpc_network_id
  private_subnet_id = module.network.private_subnet_id
  user_db_pass      = var.user_db_pass
  postgres_admin_pass    = var.postgres_admin_pass
}

# VM для хостинга
module "app_instance" {
  source             = "./modules/compute_instance"
  folder_id          = var.yc_folder_id
  subnet_id          = module.network.private_subnet_id
  service_account_id = module.app_server_sa.service_account_id
  vm_name            = "django-app2"
  ssh_key            = file("~/.ssh/authorized_keys")
  public_ip          = true
}
