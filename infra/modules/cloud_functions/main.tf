terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.140"
    }
  }
}

resource "yandex_serverless_function" "this" {
  name               = var.function_name
  description        = "Image preview and processing function"
  runtime            = "python39"
  entrypoint         = "main.handler"
  memory             = 512
  execution_timeout  = 15
  service_account_id = var.service_account_id

  environment = {
    BUCKET_NAME           = var.bucket_name
    AWS_ACCESS_KEY_ID     = var.storage_access_key
    AWS_SECRET_ACCESS_KEY = var.storage_secret_key
    MAX_IMAGE_SIZE        = var.max_image_size
    ALLOWED_EXTENSIONS    = "jpg,jpeg,png,gif"
  }

  content {
    zip_filename = "${path.module}/function/function.zip"
  }
}