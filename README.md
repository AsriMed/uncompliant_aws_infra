# CloudCRM AWS Infrastructure Simulation

This project simulates the AWS-based infrastructure of CloudCRM, a fictional French SaaS startup offering customer relationship management solutions to SMEs. The infrastructure contains deliberate compliance violations for testing the ComplianceAI Agent.

## Overview

This project sets up the following AWS resources with intentional compliance issues:

1. **Network Infrastructure**:
   - VPC with public subnets only (missing private subnets)
   - Overly permissive security groups
   - No VPC flow logs for traffic monitoring

2. **Ubuntu EC2 Instance**:
   - Insecure user data script with hardcoded credentials
   - Excessive IAM permissions (administrator access)
   - Unencrypted EBS volumes

3. **RDS Database**:
   - Publicly accessible (violates GDPR Article 32)
   - Unencrypted at rest (violates GDPR Article 32)
   - Using outdated engine version

4. **Web Application**:
   - S3 bucket with public access
   - CloudFront distribution without HTTPS enforcement
   - Tracking scripts without user consent (violates GDPR Article 7)

## Directory Structure

```
CloudCRM/
├── terraform/                     # Terraform configuration files
│   ├── main.tf                    # Main configuration file
│   ├── provider.tf                # AWS provider configuration
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Output values
│   └── modules/                   # Terraform modules
│       ├── vpc/                   # VPC module with networking resources
│       ├── ec2/                   # EC2 module with an Ubuntu instance
│       ├── rds/                   # RDS module with a MySQL database
│       └── webapp/                # Web application module with S3 and CloudFront
├── logs/                          # Sample log files with compliance issues
│   └── cloudcrm_activity.log      # Activity logs with compliance violations
├── docs/                          # Documentation files
│   └── compliance_issues.md       # Detailed explanation of compliance issues
└── app/                           # Application files (placeholder)
```

## Prerequisites

- AWS Account
- AWS CLI configured with appropriate credentials
- Terraform 0.13.0 or later
- Git (for cloning the repository)

## Deployment Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/cloudcrm-aws.git
cd cloudcrm-aws
```

### 2. Initialize Terraform

```bash
cd terraform
terraform init
```

### 3. Review and Configure Variables

Review the variables in `terraform/variables.tf` and create a `terraform.tfvars` file if you want to override any default values:

```bash
# Example terraform.tfvars content
aws_region = "eu-west-3"  # Paris region for a French company
project_name = "cloudcrm"
db_password = "Password123!" # Deliberately weak password
```

### 4. Plan the Deployment

```bash
terraform plan -out=tfplan
```

### 5. Apply the Configuration

```bash
terraform apply tfplan
```

### 6. Access the Infrastructure

After deployment, Terraform will output:
- EC2 instance public IP
- RDS endpoint
- Web application URL

You can access:
- Web application: http://[cloudfront-domain]
- EC2 instance: ssh ubuntu@[ec2-public-ip]
- RDS database: mysql -h [rds-endpoint] -u admin -p

### 7. Clean Up Resources

When you're done testing, remember to destroy the resources to avoid unnecessary AWS charges:

```bash
terraform destroy
```

## Intentional Compliance Issues

This infrastructure contains the following deliberate compliance issues for testing the ComplianceAI Agent:

### GDPR Violations

1. **Article 5 (Data Minimization)**:
   - Logs containing PII without anonymization
   - No data retention policies

2. **Article 6 & 7 (Lawful Basis and Consent)**:
   - Web application using tracking scripts without consent
   - Customer creation without storing GDPR consent status

3. **Article 32 (Security of Processing)**:
   - Unencrypted database (RDS)
   - HTTP instead of HTTPS (CloudFront)
   - Public access to sensitive data (S3)
   - Weak passwords and exposed credentials

### ANSSI Security Recommendations Violations

1. **Network Security**:
   - Overly permissive security groups (0.0.0.0/0)
   - Missing private subnets
   - No VPC flow logs

2. **Access Management**:
   - Excessive IAM permissions
   - Hardcoded credentials
   - Weak passwords

3. **Data Protection**:
   - Unencrypted data at rest
   - Unencrypted data in transit
   - Public access to sensitive data

4. **Monitoring and Logging**:
   - No CloudTrail
   - No CloudWatch alarms
   - Sensitive data in logs

## Testing with ComplianceAI

The ComplianceAI Agent can scan this infrastructure to detect compliance issues and suggest remediation. The expected compliance score should be low (around 30-40%) due to the deliberate violations.

Expected findings include:
- Insufficient data protection mechanisms
- Weak authentication
- Insecure network configuration
- Missing encryption
- Improper logging and monitoring

## Disclaimer

This project is designed for educational purposes only to demonstrate non-compliant infrastructure. The deliberately introduced compliance issues should never be used in production environments.

## License

This project is licensed under the MIT License - see the LICENSE file for details.