variable "sg_name" {}
variable "vpc_id" {}

output "sg_id" {
  value = aws_security_group.mern_sg.id
}

resource "aws_security_group" "mern_sg" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
  description = "To enable ports: 80(HTTP) and 443(HTTPS) "

  #http traffic
  ingress {
    description = "To enable port 80"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  #https traffic
  ingress {
    description = "To enable port 443"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  #outbound traffic
  egress {
    description = "Allow outgoing traffic"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "MERN Security Group"
  }

}