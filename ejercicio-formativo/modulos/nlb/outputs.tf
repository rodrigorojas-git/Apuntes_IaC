output "dns_name" {
  description = "DNS del NLB"
  value       = aws_lb.this.dns_name
}

output "nlb_arn" {
  description = "ARN del NLB"
  value       = aws_lb.this.arn
}
