# Debugging

## Orden para revisar un problema

1. `terraform fmt` para el formato
2. `terraform validate` revisa el código (sintaxis, referencias), sin consultar state ni AWS
3. `terraform plan` compara con el state y con AWS
4. `terraform console` para probar una expresión
5. `TF_LOG` para ver los logs

**validate vs plan:** validate solo revisa el código. Errores como un índice fuera de rango, un `for_each` desconocido o credenciales malas recién aparecen en el `plan`.

## TF_LOG

Niveles (de menos a más detalle): `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`.

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

- Sin `TF_LOG_PATH` el log sale por pantalla; con `TF_LOG_PATH` se guarda en un archivo.
- `TRACE` es el más detallado y puede traer datos sensibles. No subirlo al repo.
- Ver el log: `head -20 logs/terraform-debug.log` o `Get-Content logs/terraform-debug.log -TotalCount 20`.

## Leer el plan

- `+` crear
- `-` destruir
- `~` modificar sin destruir
- `-/+` destruir y volver a crear (ojo, puede haber downtime)

## Errores comunes

```
Error: Reference to undeclared resource       -> nombre mal escrito o no declarado
Error: Reference to undeclared input variable -> falta el bloque variable
Error: Unsupported argument                   -> argumento mal escrito ("Did you mean...?")
Error: Missing required argument              -> falta un argumento (o una variable del módulo)
Error: Unclosed configuration block           -> falta una llave }
Error: Module not installed                   -> falta terraform init
Error: Cycle                                  -> dos recursos se referencian entre sí
Error: No value for required variable         -> variable sin default y sin valor
Error: Output refers to sensitive values      -> al output le falta sensitive = true
Error: No valid credential sources found      -> faltan credenciales de AWS
Error acquiring the state lock                -> otro proceso usa el state
```

Un detalle: si escribo `locals.nombre` en vez de `local.nombre`, el error dice *Reference to undeclared resource*. Se declara con `locals` pero se usa con `local`.

## State

```
terraform state list              # recursos que hay en el state
terraform state show <recurso>    # detalle de uno
terraform show                    # todo el state
terraform state rm <recurso>      # lo saca del state (no lo destruye)
terraform apply -replace=<recurso>   # fuerza recrear un recurso
terraform force-unlock <ID>       # solo si el lock quedó pegado y nadie está aplicando
```

Nunca editar `terraform.tfstate` a mano ni subirlo a GitHub.

## Otros

- `terraform plan -detailed-exitcode`: 0 sin cambios, 1 error, 2 hay cambios.
- Drift: alguien cambió algo a mano en AWS. El `plan` lo muestra.
