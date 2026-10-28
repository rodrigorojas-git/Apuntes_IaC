# Variables y Outputs

## Variables

```hcl
variable "instancias" {
  type        = number
  description = "Cantidad de servidores"
  default     = 2            # si no tiene default, es obligatoria
  sensitive   = false

  validation {
    condition     = var.instancias > 0 && var.instancias <= 10
    error_message = "Debe estar entre 1 y 10."
  }
}
```

Se usan con `var.instancias`.

### Tipos

- Simples: `string`, `number`, `bool`
- `list(string)`: lista ordenada, `["a","b"]`
- `set(string)`: sin repetidos ni orden
- `map(string)`: clave -> valor, `{ a = "x" }`
- `object({ motor = string, storage = number })`: atributos con tipos distintos
- `tuple([string, number])`: largo y tipos fijos

`optional()` en un object: `storage = optional(number, 20)` (si no lo pasan, vale 20).

## Cómo se pasan los valores

1. `default` de la variable
2. Variable de entorno `TF_VAR_nombre`
3. `terraform.tfvars` (se carga solo)
4. `*.auto.tfvars` (se cargan solos)
5. `-var="nombre=valor"` o `-var-file="prod.tfvars"`

**Precedencia** (gana el último): default < TF_VAR_ < terraform.tfvars < *.auto.tfvars < -var / -var-file

Ejemplo: si `TF_VAR_region="ap-south-1"` y en `terraform.tfvars` dice `region = "us-west-2"`, se usa `us-west-2`.

`prod.tfvars` no se carga solo, hay que usar `-var-file`.

Si una variable no tiene default ni valor, Terraform me la pregunta.

## Variables sensibles

```hcl
variable "password_db" {
  type      = string
  sensitive = true
}
```

- En el plan/apply sale `(sensitive value)`.
- Igual queda guardada en el state, así que hay que proteger el state.
- Si un output usa un valor sensible, el output necesita `sensitive = true`. Si no, da el error *Output refers to sensitive values*.

## Outputs

```hcl
output "ip_publica" {
  description = "IP pública del servidor"
  value       = aws_instance.web.public_ip
}
```

```
terraform output                 # todos
terraform output ip_publica      # uno
terraform output -raw ip_publica # sin comillas (para scripts)
terraform output -json           # todos en JSON
```

Los outputs sirven para:
1. Mostrar datos después del apply (IPs, URLs).
2. Pasar valores entre módulos: `module.nombre.output`.
3. Que otras herramientas los lean (`-json`).

## Referencias

```
var.nombre        local.nombre        module.nombre.output
recurso.tipo.nombre.atributo          data.tipo.nombre.atributo
```
