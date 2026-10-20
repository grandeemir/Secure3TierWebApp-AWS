resource "aws_lb" "backend_alb" {
  name                       = "${var.project_name}-${var.environment}-backend-alb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [var.backend_alb_sg]
  subnets                    = var.private_subnets
  drop_invalid_header_fields = true

  tags = var.tags
}


resource "aws_lb_target_group" "backend_tg" {
  name_prefix = "backtg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}