variable "prefijo" {
  type        = string
  description = "Prefijo de los nombres"
}

variable "buckets" {
  type        = set(string)
  description = "Nombres de los buckets a crear"
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes"
  default     = {}
}
