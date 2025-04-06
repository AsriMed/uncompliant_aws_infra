output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.cloudcrm.id
}

output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.cloudcrm.endpoint
}

output "db_instance_address" {
  description = "Address of the RDS instance"
  value       = aws_db_instance.cloudcrm.address
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db_sg.id
} 