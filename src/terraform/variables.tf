#Токен доступа к yandex.cloud
variable "token" {
  type      = string
  default = "y0_AgAAAAAj9_U2AATuwQAAAADR4scx4JoRe4gYSOqkOwcDRABmPhualgM"
#  sensitive = true
}

#ID облака
variable "cloud_id" {
  type    = string
  default = "b1gb8tnrcg5uk53e5b74"
}

#ID каталога
variable "folder_id" {
  type    = string
  default = "b1g8ic24egn6vfq98qiu"
}
#Белый IP
variable "yc_dedicated_ip" {
  default = "51.250.10.169"
}
#Доменное имя
variable "domain_name" {
  type    = string
  default = "maksam.ru"
}
