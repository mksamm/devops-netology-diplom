terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "= 0.80.0"
    }
  }
}

provider "yandex" {
  token = "y0_AgAAAAAj9_U2AATuwQAAAADR4scx4JoRe4gYSOqkOwcDRABmPhualgM"
  cloud_id  = "b1gb8tnrcg5uk53e5b74"
  folder_id = "b1g8ic24egn6vfq98qiu"
  zone      = "ru-central1-a"
}
