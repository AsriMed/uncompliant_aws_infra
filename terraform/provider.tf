provider "aws" {
  # COMPLIANCE ISSUE: Using an outdated provider version with known vulnerabilities
  version = "~> 3.0"  # Should use >= 4.0 for better security features and compliance
  
  region = var.aws_region
  
  # COMPLIANCE ISSUE: No explicit credential handling strategy (security best practice violation)
  # Should use proper credential management like AWS SSM Parameter Store or Secrets Manager
  
  # COMPLIANCE ISSUE: No default encryption for S3 or other resources (GDPR Article 32 violation)
  default_tags {
    tags = {
      Environment = var.environment
      Project     = "CloudCRM"
      Terraform   = "true"
    }
  }
} 