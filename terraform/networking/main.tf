data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "first" {
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Default subnet for ap-southeast-1a"
  }
}
resource "aws_default_subnet" "second" {
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "Default subnet for ap-southeast-1b"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id
  tags = {
    "Name" = "Default Security Group"
  }
  ingress = [{
    from_port        = 22
    description      = ""
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }, {
    from_port        = 443
    description      = ""
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }]


  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
