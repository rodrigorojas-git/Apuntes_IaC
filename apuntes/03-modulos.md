# Módulos

- Un módulo es cualquier carpeta con archivos `.tf`.
- **Root module**: la carpeta donde ejecuto `terraform apply`.
- **Child module**: el que llamo desde otro con un bloque `module {}`.
- Cada módulo tiene su propio scope: no veo los recursos de otro módulo.

```
proyecto/              <- root
├── main.tf
├── variables.tf
├── outputs.tf
└── modulos/
    └── vpc/           <- child
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

Estructura estándar de un módulo: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` y `README.md`.

## Llamar a un módulo

```hcl
module "vpc" {
  source   = "./modulos/vpc"    # obligatorio
  vpc_cidr = "10.0.0.0/16"      # = variable "vpc_cidr" del módulo
}

output "vpc_id" {
  value = module.vpc.vpc_id     # module.<nombre>.<output>
}
```

- Los argumentos del bloque `module` son las **variables** del módulo hijo.
- Lo único que puedo leer del hijo son sus **outputs**. Si intento `module.vpc.aws_vpc.this.id` da error (es una caja negra).
- Después de agregar un módulo hay que correr `terraform init` (si no: *Module not installed*).

## source

- Local: `"./modulos/vpc"`
- Registry: `"terraform-aws-modules/vpc/aws"`
- GitHub: `"github.com/org/repo"`
- Git: `"git::https://ejemplo.com/vpc.git?ref=v1.2"`

**`version` solo funciona con módulos del registry.** Para Git se usa `?ref=`.

Versiones: `"~> 5.0"` es cualquier 5.x (no 6.0); `">= 5.0"` es 5.0 o más; `"5.5.3"` es exacta.

## Pasar datos entre módulos

Un módulo no puede leer a otro directamente, entonces:

1. El módulo A declara un **output**.
2. En la raíz, ese output se pasa como argumento al módulo B.
3. El módulo B lo recibe en una **variable**.

```hcl
module "ec2" {
  source    = "./modulos/ec2"
  subnet_id = module.vpc.subnet_ids[0]   # output de vpc -> variable de ec2
}
```

## count y for_each en módulos

```hcl
module "servidor" {
  count  = 2
  source = "./modulos/ec2"
  nombre = "web-${count.index + 1}"
}
# module.servidor[0].instance_id    o    module.servidor[*].instance_id

module "ambiente" {
  for_each = toset(["dev", "prod"])
  source   = "./modulos/ec2"
  nombre   = each.key
}
# module.ambiente["dev"].instance_id
```

## Providers

- Los módulos **heredan** el provider del root. No hay que declararlo de nuevo.
- Para otra región/cuenta se usan alias y `providers = { aws = aws.otra }` en el `module`.

## Buenas prácticas

- Versionar los módulos del registry.
- No dejar valores fijos adentro del módulo: usar variables.
- Exponer solo los outputs que otro módulo necesite.
- No anidar más de 2 o 3 niveles.
