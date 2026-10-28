output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.this.id
}

output "subnet_ids" {
  description = "IDs de las subredes (en el mismo orden que los CIDR)"
  value       = aws_subnet.this[*].id
}
