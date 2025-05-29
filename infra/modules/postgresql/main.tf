terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_mdb_postgresql_cluster" "notes_db_cluster" {
  name        = var.cluster_name
  environment = "PRODUCTION"
  network_id  = var.network_id  # ID сети notes-network

  config {
    version = "16"  # Версия PostgreSQL
    postgresql_config = {
      max_connections                   = 200
      enable_parallel_hash              = true
      vacuum_cost_limit                 = 2000
    }
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-hdd"
      disk_size          = 10  # Размер диска в ГБ
    }

    backup_window_start {
      hours   = 5
      minutes = 0
    }
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = var.private_subnet_id  # ID подсети private_subnet
    assign_public_ip = false  # Без публичного IP
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = var.private_subnet_id
    assign_public_ip = false
  }

  deletion_protection = false  # после тестов включить true
}

resource "yandex_mdb_postgresql_user" "django_user" {
  cluster_id = yandex_mdb_postgresql_cluster.notes_db_cluster.id
  name       = "django_user"
  password   = var.user_db_pass
}
#resource "yandex_mdb_postgresql_user" "postgres" {
#  cluster_id = yandex_mdb_postgresql_cluster.notes_db_cluster.id
#  name       = "postgres"
#  password   = var.postgres_admin_pass
#}

resource "yandex_mdb_postgresql_database" "notes_db" {
  cluster_id = yandex_mdb_postgresql_cluster.notes_db_cluster.id
  name       = "notes_db"
  owner      = yandex_mdb_postgresql_user.django_user.name
}