variable "project" {
  type = string
}

variable "environment" {
  type = string
}


variable "db_host" {
  type = string
}

variable "db_database" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "app_key" {
  type      = string
  sensitive = true
}
