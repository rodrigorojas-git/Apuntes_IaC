output "sufijo" {
  description = "Sufijo random de 6 caracteres"
  value       = local.sufijo
}

output "vpc_id" {
  description = "ID de la VPC"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "IDs de las subredes"
  value       = module.vpc.subnet_ids
}

output "ec2_ids" {
  description = "IDs de las EC2"
  value       = module.ec2[*].instance_id
}

output "nlb_dns" {
  description = "DNS de los NLB"
  value       = module.nlb[*].dns_name
}

output "buckets" {
  description = "Nombres de los buckets"
  value       = module.s3.bucket_names
}
