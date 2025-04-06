output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.cloudcrm_instance.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.cloudcrm_instance.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.cloudcrm_instance.private_ip
}

output "instance_security_group_id" {
  description = "ID of the instance security group"
  value       = aws_security_group.instance_sg.id
} 