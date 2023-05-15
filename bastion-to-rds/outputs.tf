output "bastion_host" {
  value = aws_instance.bastion.public_dns 
}

output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

output "db_address" {
  value = aws_db_instance.db_instance.address
}

output "db_port" {
  value = aws_db_instance.db_instance.port
}