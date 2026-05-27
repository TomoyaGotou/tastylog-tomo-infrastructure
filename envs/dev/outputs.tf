output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_1a_id" {
  value = module.vpc.public_subnet_1a_id
}

output "public_subnet_1c_id" {
  value = module.vpc.public_subnet_1c_id
}

output "private_subnet_1a_id" {
  value = module.vpc.private_subnet_1a_id
}

output "private_subnet_1c_id" {
  value = module.vpc.private_subnet_1c_id
}

output "public_subnet_1a_cidr_block" {
  value = module.vpc.public_subnet_1a_cidr_block
}

output "public_subnet_1c_cidr_block" {
  value = module.vpc.public_subnet_1c_cidr_block
}

output "private_subnet_1a_cidr_block" {
  value = module.vpc.private_subnet_1a_cidr_block
}

output "private_subnet_1c_cidr_block" {
  value = module.vpc.private_subnet_1c_cidr_block
}
