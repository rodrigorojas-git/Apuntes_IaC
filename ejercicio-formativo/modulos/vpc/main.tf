data "aws_availability_zones" "disponibles" {
  state = "available"
}

locals {
  nombre = "${var.prefijo}-vpc"
  tags   = merge(var.tags, { Modulo = "vpc" })
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = merge(local.tags, { Name = local.nombre })
}

# Una subred por cada CIDR de la lista, cada una en una AZ distinta
resource "aws_subnet" "this" {
  count = length(var.cidr_subredes)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cidr_subredes[count.index]
  availability_zone = data.aws_availability_zones.disponibles.names[count.index]

  tags = merge(local.tags, { Name = "${var.prefijo}-subred-${count.index + 1}" })
}
