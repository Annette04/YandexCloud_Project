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
  bucket_name            = "alm-image-storage-bucket2"
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

resource "yandex_compute_instance" "app" {
  count = 2

  name        = "app-vm-${count.index}"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd87va5cc00gaq2f5qfb" # Ubuntu 20.04
    }
  }

  network_interface {
    subnet_id = module.network.public_subnet_id
    nat       = true
  }
}

module "load_balancer" {
  source           = "./modules/load_balancer"
  lb_name          = "app-lb"
  region           = var.yc_region
  health_check_path = "/health/"

  target_instances = [
    for vm in yandex_compute_instance.app : {
      subnet_id = module.network.public_subnet_id
      address   = vm.network_interface[0].ip_address
    }
  ]

  depends_on = [
    yandex_compute_instance.app,
    module.network
  ]
}