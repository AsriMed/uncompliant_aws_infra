variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for DB subnet group"
  type        = list(string)
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "cloudcrm"
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
}

variable "db_storage_encrypted" {
  description = "Enable storage encryption for RDS"
  type        = bool
}

variable "db_multi_az" {
  description = "Enable multi-AZ for RDS"
  type        = bool
} 