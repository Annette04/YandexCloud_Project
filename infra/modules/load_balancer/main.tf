resource "yandex_lb_network_load_balancer" "main" {
  name = var.lb_name

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.app.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = var.health_check_path
      }
    }
  }
}

resource "yandex_lb_target_group" "app" {
  name      = "${var.lb_name}-tg"
  region_id = var.region

  dynamic "target" {
    for_each = var.target_instances
    content {
      subnet_id  = target.value.subnet_id
      address    = target.value.address
    }
  }
}