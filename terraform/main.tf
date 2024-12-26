# Provider Configuration
provider "aws" {
  region = "us-east-1" # Change the region as per your requirement
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MERN-App-VPC"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a" # Change based on region
  tags = {
    Name = "Public-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet-Gateway"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "mern_sg" {
  name_prefix = "MERN-App-SG-"
  vpc_id      = aws_vpc.main.id

  # Allow SSH access from your public IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["54.149.250.191/32"] 
  }

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow MongoDB (only for internal testing, not exposed to the internet)
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Limit to the VPC
  }

  # Egress - Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MERN-App-Security-Group"
  }
}

# EC2 Instance
resource "aws_instance" "mern_instance" {
  ami           = "ami-05d38da78ce859165"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.mern_sg.name]

  # Replace with your SSH key pair
  key_name = "manish_p"

  tags = {
    Name = "MERN-App-Instance"
  }
}

# Output the Public IP of the EC2 Instance
output "instance_public_ip" {
  value = aws_instance.mern_instance.public_ip
}

