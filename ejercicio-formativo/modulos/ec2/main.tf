# Busca la última AMI de Amazon Linux 2023
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

locals {
  nombre = "${var.prefijo}-${var.nombre}"
  tags   = merge(var.tags, { Modulo = "ec2" })
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = merge(local.tags, { Name = local.nombre })
}
