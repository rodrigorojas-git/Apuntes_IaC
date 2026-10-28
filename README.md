# Apuntes Terraform · Infraestructura como Código I (AUY1103)

Apuntes para la Evaluación 2, basados en las clases del curso y en el ejercicio formativo.

## Temas de la evaluación

| Tema | Archivo |
|---|---|
| Funciones repetitivas | [apuntes/01-funciones-repetitivas.md](apuntes/01-funciones-repetitivas.md) |
| Variables y Outputs | [apuntes/02-variables-y-outputs.md](apuntes/02-variables-y-outputs.md) |
| Módulos | [apuntes/03-modulos.md](apuntes/03-modulos.md) |
| Debugging | [apuntes/04-debugging.md](apuntes/04-debugging.md) |
| Locals, local-exec y remote-exec | [apuntes/05-locals-y-provisioners.md](apuntes/05-locals-y-provisioners.md) |

## Ejercicio formativo

[ejercicio-formativo/](ejercicio-formativo/): VPC, 2 EC2, 2 NLB y 2 S3 privados usando módulos propios (vpc, ec2, nlb, s3).

## Comandos básicos

```
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```
