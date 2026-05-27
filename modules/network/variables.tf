variable "project" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_1a_cidr_block" {
  type = string
}

variable "public_subnet_1c_cidr_block" {
  type = string
}

variable "public_subnet_1a_availability_zone" {
  type = string
}

variable "public_subnet_1c_availability_zone" {
  type = string
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "private_subnet_1a_cidr_block" {
  type = string
}

variable "private_subnet_1c_cidr_block" {
  type = string
}

variable "private_subnet_1a_availability_zone" {
  type = string
}

variable "private_subnet_1c_availability_zone" {
  type = string
}
