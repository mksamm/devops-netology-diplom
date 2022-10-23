locals {
 name_web_host = {
  stage = "app"
  prod = "ap-+prod"
 }
name_gitlab_host = {
stage = "gitlab"
prod = "gitlab-prod"
}
name_monitoring_host = {
  stage = "monitoring"
  prod = "monitoring-prod"
 }
Foo = "${yandex_compute_instance.maksam.network_interface.0.nat_ip_address}"
}
