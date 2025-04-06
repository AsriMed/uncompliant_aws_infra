terraform {
  required_version = ">= 0.13.0"
  
  # COMPLIANCE ISSUE: No backend configuration for state (DevOps best practice violation)
  # Should use S3 backend with encryption and DynamoDB for locking
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # COMPLIANCE ISSUE: Outdated provider version (security best practice violation)
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Create VPC and network resources
module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  aws_region   = var.aws_region
}

# Create RDS instance with compliance issues
module "rds" {
  source = "./modules/rds"
  
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids # COMPLIANCE ISSUE: Using public subnets for database
  
  db_username         = var.db_username
  db_password         = var.db_password
  db_instance_class   = var.db_instance_class
  db_storage_encrypted = var.db_storage_encrypted
  db_multi_az         = var.db_multi_az
}

# Create EC2 instance with compliance issues
module "ec2" {
  source = "./modules/ec2"
  
  project_name  = var.project_name
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  instance_type = var.ec2_instance_type
}

# Create web application with compliance issues
module "webapp" {
  source = "./modules/webapp"
  
  project_name = var.project_name
} 