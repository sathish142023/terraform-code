resource "aws_instance" "Test" {
  ami                    = "ami-0a0ad243acfd35893"
  instance_type          = "t2.micro"
  key_name               = "Linux-Web"
  vpc_security_group_ids = ["Linux-Web-SG"]
  tags = {
    Name = "Web-server"
  }
}
