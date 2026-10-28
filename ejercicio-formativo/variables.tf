variable "region" {
  type        = string
  description = "Región de AWS"
  default     = "us-east-1"
}

variable "proyecto" {
  type        = string
  description = "Nombre del proyecto (se usa como prefijo en los nombres)"

  # S3 solo acepta minúsculas, números y guiones
  validation {
    condition     = can(regex("^[a-z0-9-]{3,12}$", var.proyecto))
    error_message = "El proyecto debe tener entre 3 y 12 caracteres: minúsculas, números y guiones."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR de la VPC"
}

variable "cidr_subredes" {
  type        = list(string)
  description = "CIDR de cada subred (se crea 1 EC2 y 1 NLB por subred)"
}

variable "buckets" {
  type        = set(string)
  description = "Nombres de los buckets S3 privados"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2"
  default     = "t3.micro"
}

variable "puerto_nlb" {
  type        = number
  description = "Puerto TCP del NLB"
  default     = 80
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes"
  default = {
    Gestionado = "terraform"
    Curso      = "IaC-I"
  }
}
