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

#create a route53 record to point to the backend ALB. The record will be used to access the backend ALB using a friendly name instead of the ALB DNS name. The record will be created in the hosted zone specified by the zone_id variable and will have a name in the format of *.backend-alb-environment.domain_name. 
  
resource "aws_route53_record" "backend_alb" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.environment}.${var.domain_name}"
  type    = "A"
  allow_overwrite = true
  alias {
    # These are ALB details, not our domain details
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}

