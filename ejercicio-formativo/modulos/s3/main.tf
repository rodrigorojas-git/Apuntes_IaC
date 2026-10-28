locals {
  tags = merge(var.tags, { Modulo = "s3" })
}

# Un bucket por cada nombre. El prefijo tiene el random, así el nombre es único
resource "aws_s3_bucket" "this" {
  for_each = var.buckets

  bucket        = "${var.prefijo}-${each.key}"
  force_destroy = true # para que terraform destroy funcione aunque tenga archivos

  tags = local.tags
}

# Esto es lo que lo deja privado
resource "aws_s3_bucket_public_access_block" "this" {
  for_each = aws_s3_bucket.this

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
