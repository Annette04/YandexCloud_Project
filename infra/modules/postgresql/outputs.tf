output "notes_db_cluster_id" {
  description = "ID кластера PostgreSQL"
  value       = yandex_mdb_postgresql_cluster.notes_db_cluster.id
}

output "notes_db_cluster_name" {
  description = "Имя кластера PostgreSQL"
  value       = yandex_mdb_postgresql_cluster.notes_db_cluster.name
}

output "notes_db_name" {
  description = "Имя базы данных"
  value       = yandex_mdb_postgresql_cluster.notes_db_cluster.database[0].name
}

output "notes_db_user_name" {
  description = "Имя пользователя базы данных"
  value       = yandex_mdb_postgresql_cluster.notes_db_cluster.user[0].name
}

output "notes_db_host_fqdns" {
  description = "FQDN хостов в кластере"
  value       = [for host in yandex_mdb_postgresql_cluster.notes_db_cluster.host : host.fqdn]
}