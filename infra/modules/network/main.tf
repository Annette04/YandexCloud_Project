resource "yandex_vpc_network" "network" {
  name = var.network_name
}

# Публичная подсеть
resource "yandex_vpc_subnet" "public_subnet" {
  name           = "${var.network_name}-public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

# Приватная подсеть
resource "yandex_vpc_subnet" "private_subnet" {
  name           = "${var.network_name}-private"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}