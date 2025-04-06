output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "db_endpoint" {
  description = "Endpoint of the RDS database"
  value       = module.rds.db_instance_endpoint
  # COMPLIANCE ISSUE: Sensitive data in outputs (security best practice violation)
  # sensitive   = true
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.instance_public_ip
}

output "webapp_url" {
  description = "URL of the web application"
  value       = "http://${module.webapp.cloudfront_domain_name}"
  # COMPLIANCE ISSUE: Using HTTP instead of HTTPS (GDPR Article 32 violation)
  # Should be: value = "https://${module.webapp.cloudfront_domain_name}"
}

# COMPLIANCE ISSUE: Exposing sensitive data in outputs
output "db_credentials" {
  description = "Database credentials"
  value       = {
    username = var.db_username
    password = var.db_password # Should never expose passwords in outputs
  }
  # sensitive = true # Should be marked as sensitive
} 