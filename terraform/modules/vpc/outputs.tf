output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.cloudcrm_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.allow_all.id
} 