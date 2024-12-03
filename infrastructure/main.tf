# main.tf

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = { Name = "restricted-vpc" }
}

# Subnets in each availability zone
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.subnet_cidr[0]
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.subnet_cidr[1]
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.subnet_cidr[2]
  availability_zone = "eu-central-1c"
  map_public_ip_on_launch = true
}

# Security Group with SSH and PostgreSQL access
resource "aws_security_group" "main_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres_instance" {
  identifier              = "restricted-db-instance"
  instance_class          = var.db_instance_class
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "13.4"
  username                = "admin"
  password                = "strongpassword123"
  skip_final_snapshot     = true
  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.main_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.main_subnet_group.name
}

resource "aws_db_subnet_group" "main_subnet_group" {
  name       = "restricted-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
}

# EC2 Instance
resource "aws_instance" "web_instance" {
  ami           = "ami-017095afb82994ac7" # Update with a region-appropriate AMI
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_a.id
  security_groups = [aws_security_group.main_sg.name]

  tags = { Name = "restricted-ec2-instance" }
}

# IAM Role and Policy
resource "aws_iam_role" "ec2_role" {
  name               = "restricted-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Route 53 Hosted Zone
# resource "aws_route53_zone" "main_zone" {
#  name = "myrestrictedzone.com"  # Replace with your domain
# }

# IAM Policy for Route53 access
resource "aws_iam_policy" "route53_access_policy" {
  name = "Route53Access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["route53:*"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_route53_policy" {
  policy_arn = aws_iam_policy.route53_access_policy.arn
  role       = aws_iam_role.ec2_role.name
}
