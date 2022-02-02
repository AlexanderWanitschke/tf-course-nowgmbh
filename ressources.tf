resource "aws_instance" "app_server" {
  ami           = "ami-04c921614424b07cd" # Das Ist ein Kommentar
  instance_type = "t2.micro"
  tags = {
    Name = "mro-test"
  }
}
