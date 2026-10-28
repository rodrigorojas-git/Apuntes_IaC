variable "prefijo" {
  type        = string
  description = "Prefijo de los nombres"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR de la VPC"
}

variable "cidr_subredes" {
  type        = list(string)
  description = "CIDR de las subredes"
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes"
  default     = {}
}
