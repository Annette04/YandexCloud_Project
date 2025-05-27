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
      admin_password = var.postgres_admin_pass
      max_connections                   = 200
      enable_parallel_hash              = true
      vacuum_cost_limit                 = 2000
      default_transaction_isolation     = "READ COMMITTED"
      shared_preload_libraries          = "pg_stat_statements, auto_explain"
    }
    resources {
      resource_preset_id = "s3-c2-m8"  # Intel Ice Lake, 2 vCPU, 8 ГБ RAM
      disk_type_id       = "network-hdd"
      disk_size          = 20  # Размер диска в ГБ
    }

    backup_window_start {
      hours   = 1
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

  user {
    name     = "django_user"
    password = var.user_db_pass
    permission {
      database_name = "notes_db"
    }
  }

  database {
    name  = "notes_db"
    owner = "django_user"
  }

  deletion_protection = false  # после тестов включить true
}