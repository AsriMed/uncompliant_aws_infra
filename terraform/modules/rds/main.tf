resource "aws_db_subnet_group" "cloudcrm" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids
  
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# COMPLIANCE ISSUE: Database security group with overly permissive access (ANSSI recommendation violation)
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow database access"
  vpc_id      = var.vpc_id
  
  # COMPLIANCE ISSUE: Allows MySQL/PostgreSQL access from anywhere
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Should be restricted to application servers
    description = "MySQL access"
  }
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Should be restricted to application servers
    description = "PostgreSQL access"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-db-sg"
  }
}

# COMPLIANCE ISSUE: Database instance with multiple compliance issues
resource "aws_db_instance" "cloudcrm" {
  identifier           = "${var.project_name}-db"
  engine               = "mysql"
  engine_version       = "5.7" # COMPLIANCE ISSUE: Using outdated engine version (security best practice violation)
  instance_class       = var.db_instance_class
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password # COMPLIANCE ISSUE: Hardcoded password (ANSSI recommendation violation)
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.cloudcrm.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  allocated_storage    = 20
  storage_type         = "gp2"
  
  # COMPLIANCE ISSUE: Database publicly accessible (GDPR Article 32 violation)
  publicly_accessible = true # Should be false
  
  # COMPLIANCE ISSUE: No encryption at rest (GDPR Article 32 violation)
  storage_encrypted = var.db_storage_encrypted # Set to false by default
  
  # COMPLIANCE ISSUE: No automated backups (GDPR Article 32 violation)
  backup_retention_period = 0 # Should be at least 7 days
  
  # COMPLIANCE ISSUE: No deletion protection (DevOps best practice violation)
  deletion_protection = false # Should be true for production
  
  # COMPLIANCE ISSUE: No multi-AZ deployment (resiliency best practice violation)
  multi_az = var.db_multi_az # Set to false by default
  
  # COMPLIANCE ISSUE: No performance insights (monitoring best practice violation)
  performance_insights_enabled = false # Should be true
  
  # COMPLIANCE ISSUE: Skip final snapshot (data protection best practice violation)
  skip_final_snapshot = true # Should be false
  
  # COMPLIANCE ISSUE: Auto minor version upgrade disabled (security best practice violation)
  auto_minor_version_upgrade = false # Should be true
  
  tags = {
    Name = "${var.project_name}-db"
  }
} 