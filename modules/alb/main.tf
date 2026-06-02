#------------------------
# ALB
#------------------------
#cloudfrontからのリクエストを受付。ALBはHTTPS通信を提供し、ACMで発行したSSL証明書を使用。
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.alb_sg_id]

  subnets = var.public_subnet_ids

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

#------------------------
# ALB Target Group
#------------------------
#ALBのターゲットグループを作成するモジュール。ECSFargateのIPアドレスをターゲットとして登録。
#ヘルスチェックは、/healthエンドポイントにHTTPリクエストを送信し、200レスポンスが返ってくるかで判定。
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.project}-${var.environment}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  deregistration_delay = 60

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project}-${var.environment}-alb-tg"
    Project     = var.project
    Environment = var.environment
  }
}

#------------------------
# ALB listener
#------------------------
#albのリスナーを作成するモジュール。HTTPSリクエストを受け付け、ALBターゲットグループに転送する設定。
#ACMで発行したSSL証明書のARNを指定
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
  tags = {
    Name        = "${var.project}-${var.environment}-alb-listener"
    Project     = var.project
    Environment = var.environment
  }
}

#risenerはHTTPとHTTPSの両方を設定。HTTPリクエストはHTTPSにリダイレクトするように設定。
#HTTPリクエストをHTTPSにリダイレクトするため
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
  tags = {
    Name        = "${var.project}-${var.environment}-alb-listener-http"
    Project     = var.project
    Environment = var.environment
  }
}
