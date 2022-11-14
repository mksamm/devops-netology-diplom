terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "= 0.80.0"
    }
  }
}

provider "yandex" {
  token = "яндекс.клауд.токен"
  cloud_id  = "облако.ид"
  folder_id = "фолдер.ид"
  zone      = "ru-central1-a"
}
