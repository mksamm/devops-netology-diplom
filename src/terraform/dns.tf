resource "yandex_dns_zone" "maksam-ru" {
  name = "maksam-ru"
  zone = "maksam.ru."
  public = true
}

resource "yandex_dns_recordset" "record" {

  for_each = toset(["www.", "gitlab.", "grafana.", "alertmanager.", "prometheus.",""])
  zone_id = yandex_dns_zone.maksam-ru.id
  name = "${each.key}maksam.ru."
  type = "A"
  ttl = 60
  data = [
    yandex_compute_instance.maksam.network_interface[0].nat_ip_address
 ]
 depends_on = [
   yandex_compute_instance.maksam
 ]
}
