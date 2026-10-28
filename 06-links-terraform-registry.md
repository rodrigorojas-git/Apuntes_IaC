# Links útiles para la prueba

Cómo encontrar otras páginas del registry: `https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/<nombre sin aws_>`
(para data sources se usa `data-sources/` en vez de `resources/`).

## Terraform Registry (ejercicio formativo)

- VPC: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
- Subnet: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
- EC2 (`aws_instance`): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
- NLB (`aws_lb`): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
- Target group: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
- Listener: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
- Registro de destinos: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
- Bucket S3: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
- Bucket privado (bloqueo de acceso público): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
- AMI (data source): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
- Zonas de disponibilidad (data source): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
- `random_string`: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string

## Para probar provisioners sin un recurso de AWS

- `null_resource`: https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
- `terraform_data`: https://developer.hashicorp.com/terraform/language/resources/terraform-data

## Funciones repetitivas

- `count`: https://developer.hashicorp.com/terraform/language/meta-arguments/count
- `for_each`: https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
- Expresiones `for`: https://developer.hashicorp.com/terraform/language/expressions/for
- Splat `[*]`: https://developer.hashicorp.com/terraform/language/expressions/splat
- Bloques `dynamic`: https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks
- Funciones: https://developer.hashicorp.com/terraform/language/functions

## Variables y Outputs

- Usar variables (formas de pasar valores y precedencia): https://developer.hashicorp.com/terraform/language/values/variables
- Bloque `variable`: https://developer.hashicorp.com/terraform/language/block/variable
- Bloque `output`: https://developer.hashicorp.com/terraform/language/block/output

## Módulos

- Llamar a un módulo: https://developer.hashicorp.com/terraform/language/modules/syntax
- Sources de módulos: https://developer.hashicorp.com/terraform/language/modules/sources

## Debugging

- Habilitar logs (`TF_LOG`, `TF_LOG_PATH`): https://developer.hashicorp.com/terraform/internals/debugging
- `terraform validate`: https://developer.hashicorp.com/terraform/cli/commands/validate

## Locals, local-exec y remote-exec

- Bloque `locals`: https://developer.hashicorp.com/terraform/language/block/locals
- Provisioners (explicación completa): https://developer.hashicorp.com/terraform/language/provisioners
- `local-exec`: https://developer.hashicorp.com/terraform/language/provisioners#run-commands-on-the-local-machine
- `remote-exec`: https://developer.hashicorp.com/terraform/language/provisioners#run-commands-on-a-remote-resource
- Bloque `connection`: https://developer.hashicorp.com/terraform/language/provisioners#connect-to-remote-resources
