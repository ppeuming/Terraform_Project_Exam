output "rds_instance_availability_zone" {
  value       = module.app1_db.db_instance_availability_zone
  description = "The availability zone of the RDS instance"
}

output "rds_instance_address" {
  value       = module.app1_db.db_instance_address
  description = "The address of the RDS instance"
}

output "rds_instance_port" {
  value       = module.app1_db.db_instance_port
  description = "The database port"
}