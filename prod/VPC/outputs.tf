output "vpc_id" {
  value       = module.prod_vpc.vpc_id
  description = "VPC ID"
}

output "public_subnets" {
  value       = module.prod_vpc.public_subnets
  description = "Public Subnet Out List"
}

output "private_subnets" {
  value       = module.prod_vpc.private_subnets
  description = "Private Subnet Out List"
}

output "database_subnets" {
  value       = module.prod_vpc.database_subnets
  description = "Database Subnet Out List"
}

output "database_subnet_group" {
  value       = module.prod_vpc.database_subnet_group
  description = "Database subnet group"
}

output "SSH_SG_id" {
  value       = module.SSH_SG.security_group_id
  description = "SSH Security-Group ID"
}

output "HTTP_HTTPS_SG_id" {
  value       = module.HTTP_HTTPS_SG.security_group_id
  description = "HTTP_HTTPS Security-Group ID"
}

output "RDS_SG_id" {
  value       = module.RDS_SG.security_group_id
  description = "RDS Security-Group ID"
}

output "EC2_Pub_IP" {
  value       = aws_eip.BastionHost_eip.public_ip
  description = "EC2 Instance Public IP Address"
}
