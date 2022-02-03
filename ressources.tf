resource "aws_instance" "app_server" {
  count                       = var.app_server_count
  ami                         = lookup(var.ami_id, var.region) # here we use the variabile
  subnet_id                   = aws_subnet.public.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web_access.id]
  associate_public_ip_address = true
  user_data                   = file("install_webserver.sh")

  tags = {
    Name = "App Server ${count.index + 1}"
  }
}

resource "aws_security_group" "web_access" {
  name        = "sg_web_security_group_mro"
  description = "Terraform web security group"
  vpc_id      = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
