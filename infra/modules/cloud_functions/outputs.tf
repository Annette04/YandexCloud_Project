output "function_id" {
  value = yandex_function.this.id
}

output "function_url" {
  value = "https://functions.yandexcloud.net/${yandex_function.this.id}"
}