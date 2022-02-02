output "public_ip_adress_of_instance" {
  value = aws_instance.app_server.*.public_ip
}
