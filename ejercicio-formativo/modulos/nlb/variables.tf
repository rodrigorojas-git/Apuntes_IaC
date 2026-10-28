variable "prefijo" {
  type        = string
  description = "Prefijo de los nombres"
}

variable "nombre" {
  type        = string
  description = "Nombre del NLB (el nombre completo no puede pasar de 32 caracteres)"
}

variable "vpc_id" {
  type        = string
  description = "ID de la VPC (viene del módulo vpc)"
}

variable "subnet_id" {
  type        = string
  description = "Subred del NLB (viene del módulo vpc)"
}

variable "instance_id" {
  type        = string
  description = "EC2 que recibe el tráfico (viene del módulo ec2)"
}

variable "puerto" {
  type        = number
  description = "Puerto TCP"
  default     = 80
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes"
  default     = {}
}
