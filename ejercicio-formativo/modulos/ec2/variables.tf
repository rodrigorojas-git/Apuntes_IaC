variable "prefijo" {
  type        = string
  description = "Prefijo de los nombres"
}

variable "nombre" {
  type        = string
  description = "Nombre del servidor"
}

variable "subnet_id" {
  type        = string
  description = "Subred donde se crea la EC2 (viene del módulo vpc)"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia"
  default     = "t3.micro"
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes"
  default     = {}
}
