// Creating VPC
resource "aws_vpc" "app-vpc" {
  cidr_block       = "10.10.0.0/16"

  tags = {
    Name = "app-VPC"
  }
}

//Create Subnet
resource "aws_subnet" "app-subnet" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "app-subnet"
  }
}

// Create Internet-Gateway
resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "app-IGW"
  }
}

// Creating Route Table
resource "aws_route_table" "app-rt" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }

  tags = {
    Name = "app-rt"
  }
}

// associate subnet with route table
resource "aws_route_table_association" "app-rt-associate" {
  subnet_id      = aws_subnet.app-subnet.id
  route_table_id = aws_route_table.app-rt.id
}

// Create security Group

resource "aws_security_group" "app-vpc-sg" {
  name        = "app-vpc-sg"
  vpc_id      = aws_vpc.app-vpc.id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "app-vpc-sg"
  }
}

// Create Instance
resource "aws_instance" "web" {
  ami                    = "ami-0a0ad243acfd35893"
  instance_type          = "t2.micro"
  key_name               = "Linux-Web"
  vpc_security_group_ids = [aws_security_group.app-vpc-sg.id]
  subnet_id              = aws_subnet.app-subnet.id
}
