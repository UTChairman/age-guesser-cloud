provider "aws" {
  region = "us-east-1" # You can change this to your preferred AWS region
}

# 1. Create a Security Group to allow traffic to our server
resource "aws_security_group" "age_guesser_sg" {
  name        = "age_guesser_security_group"
  description = "Allow inbound traffic for Age Guesser App and Kubernetes"

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend Web Traffic
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend API Traffic
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Standard HTTP/HTTPS
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes/ArgoCD Ports (Custom node ports if needed)
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Find the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 3. Create the EC2 Instance
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # Using t3.micro as it is likely the Free Tier option in your region
  key_name      = "age_guesser_key" # We will create this key manually in AWS console

  vpc_security_group_ids = [aws_security_group.age_guesser_sg.id]

  # Allocate 20GB of storage to comfortably hold Docker images and Kubernetes
  root_block_device {
    volume_size = 20 
    volume_type = "gp3"
  }

  tags = {
    Name = "AgeGuesser-K8s-Server"
  }
}

# Output the Public IP address of the newly created server
output "public_ip" {
  value = aws_instance.app_server.public_ip
}
