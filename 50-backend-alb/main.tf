resource "aws_lb" "backend_alb" {
    name               = "${local.common_name_suffix}-backend-alb" #roboshop-dev-backend-alb
    internal           = true
    load_balancer_type = "application"
    security_groups    = [local.backend_alb_sg_id]
    subnets            = local.private_subnet_ids
    enable_deletion_protection = false # prevents accidental deletion from UI
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-backend-alb"
        }
        )
    }


# Backend ALB listening on port number 80 and protocol HTTP. It will return fixed response with status code 200 and message body "Hi, I am from backend ALB HTTP"
resource "aws_lb_listener" "backend_alb" {
    load_balancer_arn = aws_lb.backend_alb.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type = "fixed-response"
        fixed_response {
        content_type = "text/plain"
        message_body = "Hi, I am from backend ALB HTTP"
        status_code  = 200
        }
    }
}

