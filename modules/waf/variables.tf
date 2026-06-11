variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "waf_name" {
  type = string
}

variable "waf_description" {
  type = string
}

variable "allowed_ip_addresses" {
  type = list(string)
}

variable "enable_allow_japan" {
  type    = bool
  default = false
}
