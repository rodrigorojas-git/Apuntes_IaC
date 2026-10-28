# Ejercicio formativo: VPC + EC2 + NLB + S3 con módulos

## Qué pide el ejercicio

- 4 módulos propios en `modulos/`: `vpc`, `ec2`, `nlb`, `s3` (cada uno con `main.tf`, `variables.tf` y `outputs.tf`).
- 1 VPC `10.0.0.0/16` con subredes `10.0.1.0/24` y `10.0.2.0/24`.
- 2 EC2, 2 NLB (en esas subredes) y 2 buckets S3 privados.
- Variables y outputs en la raíz y en los hijos, un `locals` en todos los módulos, un `random` de 6 caracteres, `count` o `for_each`, y mostrar el debugging.

## Estructura

```
ejercicio-formativo/
├── providers.tf       aws + random
├── variables.tf
├── main.tf            random, locals y los 4 módulos
├── outputs.tf
├── terraform.tfvars   valores del ejercicio
└── modulos/
    ├── vpc/   (main.tf, variables.tf, outputs.tf)
    ├── ec2/
    ├── nlb/
    └── s3/
```

## Cómo funciona

El `random_string` (6 caracteres) se usa en un `local` de la raíz para armar el prefijo (`formativo-k3x9a2`). Ese prefijo se le pasa a los 4 módulos como variable y se usa en todos los nombres.

Los módulos se pasan datos con outputs -> variables:

- `vpc` entrega `subnet_ids` y `vpc_id`
- `ec2` recibe `subnet_id` y entrega `instance_id`
- `nlb` recibe `subnet_id`, `vpc_id` e `instance_id`
- `s3` recibe `buckets` (la lista de nombres)

## Por qué lo hice así

- **El random está en la raíz:** así hay un solo sufijo para todo, y los buckets quedan con nombre único (los nombres de S3 son únicos en todo AWS). Por eso es `upper = false` y `special = false`: S3 solo acepta minúsculas.
- **`count` para vpc, ec2 y nlb:** hay una subred por cada CIDR de la lista, y un EC2 y un NLB por subred (`count = length(var.cidr_subredes)`).
- **`for_each` para los buckets:** cada bucket tiene su nombre (`datos`, `logs`).
- **Cada EC2 va en una subred distinta** usando `module.vpc.subnet_ids[count.index]`. Cada NLB apunta a la EC2 de su misma subred con `module.ec2[count.index].instance_id`.
- **Un NLB son 4 recursos:** `aws_lb`, target group, listener y attachment (este último registra la EC2).
- **NLB interno (`internal = true`):** así no hace falta un Internet Gateway. Si lo quisiera público habría que agregar IGW y tabla de rutas.
- **Bucket privado:** `aws_s3_bucket_public_access_block` con los 4 valores en `true`. `force_destroy = true` es para que el `destroy` funcione aunque el bucket tenga archivos.
- **AMI con `data "aws_ami"`:** así no dejo un ID de AMI fijo (cambia por región).
- **Defaults:** solo en `region`, `instance_type`, `puerto_nlb` y `tags`. Lo del ejercicio (proyecto, CIDRs, buckets) va en `terraform.tfvars`, así cambio los valores sin tocar el código.
- **Locals en cada módulo:** arman el nombre (`prefijo-nombre`) y los tags con `merge`.

## Cómo ejecutarlo

Necesito credenciales de AWS configuradas (`aws configure` o variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` y `AWS_SESSION_TOKEN`).

```
terraform init
terraform validate
terraform plan        # 18 recursos
terraform apply
terraform output
terraform destroy     # al terminar, los NLB cobran por hora
```

## Debug

Linux / Git Bash:
```
export TF_LOG=DEBUG
export TF_LOG_PATH=./logs/terraform-debug.log
terraform plan
unset TF_LOG TF_LOG_PATH
```

PowerShell:
```
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "./logs/terraform-debug.log"
terraform plan
Remove-Item Env:TF_LOG, Env:TF_LOG_PATH
```

Después miro el inicio del log con `head -20 logs/terraform-debug.log` (en PowerShell: `Get-Content logs/terraform-debug.log -TotalCount 20`). La carpeta `logs/` no se sube al repo.
