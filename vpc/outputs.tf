output "private_subnets_cidr_blocks" {
  value = module.bastions_vpc.private_subnets_cidr_blocks
}

output "private_subnets_ids" {
  value = module.bastions_vpc.private_subnets
}

output "public_subnets_cidr_blocks" {
  value = module.bastions_vpc.public_subnets_cidr_blocks
}

output "public_subnets_ids" {
  value = module.bastions_vpc.public_subnets
}

output "vpc_id" {
  value = module.bastions_vpc.vpc_id
}
