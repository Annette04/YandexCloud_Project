output "public_subnet_id" {
  value = yandex_vpc_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = yandex_vpc_subnet.private_subnet.id
}

output "vpc_network_id" {
  value = yandex_vpc_network.network.id
}