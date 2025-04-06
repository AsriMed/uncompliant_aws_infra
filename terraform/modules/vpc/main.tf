resource "aws_vpc" "cloudcrm_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  # COMPLIANCE ISSUE: No VPC flow logs (ANSSI recommendation violation)
  # Flow logs should be enabled for security monitoring
  
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.cloudcrm_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true # COMPLIANCE ISSUE: Auto-assign public IPs (security best practice violation)
  
  tags = {
    Name = "${var.project_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.cloudcrm_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 2)
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true # COMPLIANCE ISSUE: Auto-assign public IPs
  
  tags = {
    Name = "${var.project_name}-public-subnet-2"
  }
}

# COMPLIANCE ISSUE: Missing private subnets (security best practice violation)
# Should create private subnets for database and backend services

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudcrm_vpc.id
  
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Create route table with public access
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloudcrm_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Associate public route table with public subnets
resource "aws_route_table_association" "public_rta_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rta_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# COMPLIANCE ISSUE: Overly permissive security groups (ANSSI recommendation violation)
resource "aws_security_group" "allow_all" {
  name        = "${var.project_name}-allow-all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.cloudcrm_vpc.id
  
  # COMPLIANCE ISSUE: Allows all ingress traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all inbound traffic"
  }
  
  # COMPLIANCE ISSUE: Allows all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  tags = {
    Name = "${var.project_name}-allow-all-sg"
  }
}

# COMPLIANCE ISSUE: No NACL restrictions (ANSSI recommendation violation)
# Should implement network ACLs for additional security 