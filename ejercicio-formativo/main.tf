# Recurso random de 6 caracteres
resource "random_string" "sufijo" {
  length  = 6
  upper   = false
  special = false
}

# Locals de la raíz (usan el random)
locals {
  sufijo  = random_string.sufijo.result
  prefijo = "${var.proyecto}-${local.sufijo}"
}

module "vpc" {
  source = "./modulos/vpc"

  prefijo       = local.prefijo
  vpc_cidr      = var.vpc_cidr
  cidr_subredes = var.cidr_subredes
  tags          = var.tags
}

# 1 EC2 por subred
module "ec2" {
  source = "./modulos/ec2"
  count  = length(var.cidr_subredes)

  prefijo       = local.prefijo
  nombre        = "web-${count.index + 1}"
  subnet_id     = module.vpc.subnet_ids[count.index]
  instance_type = var.instance_type
  tags          = var.tags
}

# 1 NLB por subred, apuntando a la EC2 de esa misma subred
module "nlb" {
  source = "./modulos/nlb"
  count  = length(var.cidr_subredes)

  prefijo     = local.prefijo
  nombre      = "web-${count.index + 1}"
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.subnet_ids[count.index]
  instance_id = module.ec2[count.index].instance_id
  puerto      = var.puerto_nlb
  tags        = var.tags
}

module "s3" {
  source = "./modulos/s3"

  prefijo = local.prefijo
  buckets = var.buckets
  tags    = var.tags
}
