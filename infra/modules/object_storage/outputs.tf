output "bucket_name" {
  description = "Имя созданного бакета"
  value       = yandex_storage_bucket.images.bucket
}

output "bucket_id" {
  description = "ID созданного бакета"
  value       = yandex_storage_bucket.images.id
}

output "bucket_domain" {
  description = "Доменное имя для доступа к бакету"
  value       = yandex_storage_bucket.images.bucket_domain_name
}