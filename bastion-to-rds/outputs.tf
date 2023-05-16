output "bastion_public_dns" {
  value = aws_instance.bastion.public_dns 
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
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

output "db_name" {
  value = aws_db_instance.db_instance.db_name
}