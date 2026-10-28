output "bucket_names" {
  description = "Nombres de los buckets"
  value       = [for b in aws_s3_bucket.this : b.bucket]
}
