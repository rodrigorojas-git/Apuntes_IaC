# Funciones repetitivas

## count

Crea N copias de un recurso.

```hcl
resource "aws_instance" "servidor" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags          = { Name = "servidor-${count.index}" }   # 0, 1, 2
}
```

- Se referencia por índice: `aws_instance.servidor[0]`
- Todos juntos (splat): `aws_instance.servidor[*].public_ip`
- Para prender/apagar un recurso: `count = var.crear ? 1 : 0`
- Ojo: identifica por índice. Si saco uno del medio de la lista, los que siguen cambian de índice y Terraform los destruye y los vuelve a crear.

## for_each

Crea una copia por cada clave de un map o de un set.

```hcl
resource "aws_subnet" "publica" {
  for_each          = { "us-east-1a" = "10.0.1.0/24", "us-east-1b" = "10.0.2.0/24" }
  availability_zone = each.key      # "us-east-1a"
  cidr_block        = each.value    # "10.0.1.0/24"
  vpc_id            = aws_vpc.principal.id
}

resource "aws_iam_user" "equipo" {
  for_each = toset(["alice", "bob"])   # con set: each.key == each.value
  name     = each.key
}
```

- Acepta **map** o **set de strings**. Si tengo una lista: `toset(var.lista)`.
- Se referencia por clave: `aws_subnet.publica["us-east-1a"]`
- Si saco una clave, solo se destruye esa.
- `count` y `for_each` **no** se pueden usar juntos en el mismo bloque.
- Con `for_each` el splat directo no sirve (`recurso[*].id` da error). Usar `[for r in recurso : r.id]` o `values(recurso)[*].id`.

### count vs for_each

- `count`: copias iguales o on/off (0 o 1). Usa `count.index`.
- `for_each`: cada copia tiene nombre o configuración distinta. Usa `each.key` y `each.value`.

## Expresiones for

```hcl
[for s in var.nombres : upper(s)]              # lista -> ["ALICE","BOB"]
{for s in var.nombres : s => upper(s)}         # map   -> {alice="ALICE", ...}
[for s in var.nombres : s if length(s) > 3]    # con filtro
{for k, v in var.tags : k => upper(v)}         # sobre un map
```

`[ ]` devuelve lista y `{ }` devuelve map (con `clave => valor`).

## Condicional

```hcl
instance_type = var.ambiente == "prod" ? "t3.large" : "t3.micro"
```

Los dos valores tienen que ser de tipos compatibles (una lista y un map juntos dan error).

## dynamic

Sirve para repetir **bloques anidados** dentro de un recurso (por ejemplo `ingress`).

```hcl
resource "aws_security_group" "web" {
  name = "sg-web"

  dynamic "ingress" {
    for_each = var.reglas_ingreso
    content {
      from_port   = ingress.value.puerto
      to_port     = ingress.value.puerto
      protocol    = ingress.value.protocolo
      cidr_blocks = [ingress.value.cidr]
    }
  }
}
```

Dentro del `content` se usa `<nombre del bloque>.value`.

## Funciones que más se usan

```
upper("web")                          "WEB"
join("-", ["a","b"])                  "a-b"
split("-", "us-east-1")               ["us","east","1"]
format("server-%02d", 5)              "server-05"
replace("a-b", "-", "_")              "a_b"
length(["a","b","c"])                 3
toset(["a","b","a"])                  ["a","b"]
merge({a=1}, {b=2}, {a=9})            {a=9, b=2}   (gana el último)
lookup({a=1}, "z", 0)                 0            (valor por defecto)
keys({a=1,b=2}) / values({a=1,b=2})   ["a","b"] / [1,2]
flatten([[1,2],[3]])                  [1,2,3]
contains(["dev","prod"], "dev")       true
element(["a","b","c"], 4)             "b"          (da la vuelta)
cidrsubnet("10.0.0.0/16", 8, 1)       "10.0.1.0/24"
```

## terraform console

Para probar expresiones antes de ponerlas en el código:

```
$ terraform console
> cidrsubnet("10.0.0.0/16", 8, 1)
"10.0.1.0/24"
```

## Errores que me pueden salir

- `for_each` con una lista: *must be a map, or set of strings* -> usar `toset()`.
- `count` y `for_each` juntos: *Invalid combination of "count" and "for_each"*.
- `var.lista[count.index]` con `count` más grande que la lista: *Invalid index*.
