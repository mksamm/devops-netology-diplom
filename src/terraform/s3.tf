terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "maksam-bucket"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJEvIu4QOIXgY4VfOcqpuQB"
    secret_key = "YCOWHqvpHm6pnDTWOWqeCZzGDtwxGbJLThe1FLLn"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
