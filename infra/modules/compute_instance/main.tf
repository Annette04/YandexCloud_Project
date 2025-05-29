terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_compute_instance" "default" {
  name        = var.vm_name
  folder_id   = var.folder_id
  zone        = var.zone
  service_account_id = var.service_account_id

  resources {
    cores         = var.cpu
    memory        = var.memory
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.disk_size
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.public_ip ? true : false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}
