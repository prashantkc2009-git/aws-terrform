// This Terraform file provisions a bastion host setup in the main AWS VPC.
// It creates a dedicated subnet, associates it with the public route table,
// configures a security group for SSH access, manages an EC2 key pair, and launches the bastion EC2 instance.

locals {
    bastion_cidr = "10.0.104.0/24"
    bastion_az   = local.azs[0]
}

resource "aws_subnet" "bastion" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = local.bastion_cidr
  availability_zone       = local.bastion_az
  map_public_ip_on_launch = true

  tags = {
    Name = "bastion-subnet"
    Type = "bastion"
    Component = "aws_subnet"
  }
}

resource "aws_route_table_association" "bastion_public" {
  subnet_id      = aws_subnet.bastion.id
  route_table_id = aws_route_table.public.id
}

# Security Group for SSH
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-ssh-sg"
  description = "Allow SSH access to bastion"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Limit to trusted IPs in production
  }

  # Allow SSH from within the same VPC (internal traffic)
  ingress {
    description = "SSH from inside VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "ec2-user-key"
  public_key = file("ec2-user-key.pub")
}

resource "aws_instance" "ec2_bastion" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.bastion.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion_key.key_name

  # Run start-up script on boot
  user_data = file("start-up-script.sh")

  tags = {
    Name = "bastion-host"
  }
}