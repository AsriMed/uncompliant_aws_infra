variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-west-3" # Paris region for a French company
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "cloudcrm"
}

# COMPLIANCE ISSUE: Insecure default passwords in variables (ANSSI recommendation violation)
variable "db_password" {
  description = "Database password"
  type        = string
  default     = "Password123!" # Should never hardcode passwords, especially weak ones
  # Should use a more secure method like AWS Secrets Manager or SSM Parameter Store
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin" # Using generic admin username
}

# COMPLIANCE ISSUE: No TLS version enforcement (ANSSI recommendation violation)
variable "enable_ssl" {
  description = "Enable SSL/TLS for resources"
  type        = bool
  default     = false # Should be true for production workloads
}

# Network variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# COMPLIANCE ISSUE: Overly permissive CIDR blocks (ANSSI recommendation violation)
variable "allowed_ips" {
  description = "IPs allowed to connect to resources"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Should be restricted to specific IPs
}

# COMPLIANCE ISSUE: Weak instance sizing (DevOps best practice violation)
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro" # May not be sufficient for production workloads
}

# RDS settings
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

# COMPLIANCE ISSUE: No encryption for RDS (GDPR Article 32 violation)
variable "db_storage_encrypted" {
  description = "Enable storage encryption for RDS"
  type        = bool
  default     = false # Should be true for GDPR compliance
}

# COMPLIANCE ISSUE: No multi-AZ deployment (resiliency best practice violation)
variable "db_multi_az" {
  description = "Enable multi-AZ for RDS"
  type        = bool
  default     = false # Should be true for production workloads
} 