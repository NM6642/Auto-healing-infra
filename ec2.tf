# EC2 Instance for Auto-Healing

resource "aws_instance" "autoheal_instance" {
  ami           = "ami-0914547665e6a707c"  
  instance_type = "t3.micro"

  tags = {
    Name    = "AutoHealInstance"
    Project = "AutoHealingInfra"
  }
}

# Security Group to allow SSH 
resource "aws_security_group" "autoheal_sg" {
  name        = "autoheal_sg"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Attach Security Group to instance
resource "aws_network_interface_sg_attachment" "sg_attach" {
  security_group_id    = aws_security_group.autoheal_sg.id
  network_interface_id = aws_instance.autoheal_instance.primary_network_interface_id
}

