# 1. Uygulama Yük Dengeleyici (ALB)
resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application" # Klasik değil, Uygulama tipi
  security_groups    = [var.alb_sg]
  subnets            = var.public_subnets

  tags = local.common_tags
}

# 2. Hedef Grubu (Target Group) - Yazdığın kod doğru, aynen kalabilir
resource "aws_lb_target_group" "web_tg" {
  name     = "${var.project_name}-${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

# 3. Dinleyici (Listener) - ALB ve TG'yi birbirine bağlayan köprü
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn # Manuel oluşturduğumuz ALB'ye bağladık
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn # Trafiği bu gruba akıt
  }
}