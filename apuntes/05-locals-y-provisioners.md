# Locals y provisioners

## locals

Valores calculados dentro del módulo que reutilizo varias veces.

```hcl
locals {
  prefijo = "${var.proyecto}-${var.ambiente}"
  nombre  = "${local.prefijo}-web"      # un local puede usar otro
  tags    = merge(var.tags, { Modulo = "ec2" })
}

resource "aws_instance" "web" {
  tags = local.tags
}
```

Se declara con `locals` (plural) y se usa con `local.` (singular).

**Variable vs local:** la variable viene de afuera y se puede cambiar (`-var`, tfvars). El local es interno, no se puede cambiar desde afuera.

## Provisioners

Ejecutan comandos cuando se crea o se destruye un recurso. Se escriben dentro del recurso y corren en el orden en que están. Son el último recurso: lo recomendado es `user_data`, Packer o Ansible.

### local-exec

Corre el comando **en mi computador** (donde ejecuto terraform).

```hcl
resource "aws_instance" "web" {
  # ...
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ips.txt"
  }
}
```

Argumentos: `command` (obligatorio), `working_dir`, `interpreter` (ej: `["/bin/bash", "-c"]` o `["PowerShell", "-Command"]`) y `environment` (variables de entorno).

### remote-exec

Corre los comandos **en el servidor remoto**. Necesita un bloque `connection`.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "mi-llave"

  connection {
    type        = "ssh"                  # o "winrm" para Windows
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("~/.ssh/mi-llave.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
    ]
  }
}
```

Para indicar qué ejecutar se puede usar **una** de estas: `inline` (lista de comandos), `script` (un script local) o `scripts` (lista de scripts).

También existe `provisioner "file"` para copiar un archivo al servidor (`source` y `destination`), y también necesita `connection`.

### when y on_failure

```hcl
provisioner "local-exec" {
  when       = destroy      # cuándo corre: create (por defecto) o destroy
  command    = "echo adiós ${self.id}"
  on_failure = continue     # si falla: fail (por defecto) o continue
}
```

- Si falla un provisioner de creación, el recurso queda **tainted** (se destruye y se vuelve a crear en el próximo apply).
- Un provisioner con `when = destroy` solo puede usar `self`, `count.index` y `each.key`. Si uso `var.algo` da *Invalid reference from destroy provisioner*.
- Los provisioners no se vuelven a ejecutar si el recurso no se recrea. Para forzarlo: `terraform apply -replace=recurso.nombre`.
- `self` es el propio recurso donde está el provisioner.

### Sin recurso real: null_resource / terraform_data

Cuando no tengo un recurso donde colgar el provisioner:

```hcl
resource "null_resource" "saludo" {
  triggers = { version = var.version_app }    # si cambia, se vuelve a ejecutar

  provisioner "local-exec" {
    command = "echo desplegando ${var.version_app}"
  }
}
```

`null_resource` es del provider `null`. En Terraform 1.4+ también existe `terraform_data`, que ya viene incluido, y usa `triggers_replace = [var.version_app]`.
