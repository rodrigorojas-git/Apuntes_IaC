# El módulo nlb necesita este id para registrar la EC2
output "instance_id" {
  description = "ID de la EC2"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "IP privada de la EC2"
  value       = aws_instance.this.private_ip
}
