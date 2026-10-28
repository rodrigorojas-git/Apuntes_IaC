locals {
  base = "${var.prefijo}-${var.nombre}"
  tags = merge(var.tags, { Modulo = "nlb" })
}

# NLB interno: así no hace falta Internet Gateway
resource "aws_lb" "this" {
  name               = "${local.base}-nlb"
  load_balancer_type = "network"
  internal           = true
  subnets            = [var.subnet_id]

  tags = local.tags
}

resource "aws_lb_target_group" "this" {
  name        = "${local.base}-tg"
  port        = var.puerto
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  tags = local.tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.puerto
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.instance_id
  port             = var.puerto
}
