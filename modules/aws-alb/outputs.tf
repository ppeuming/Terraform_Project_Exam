output "ALB_TG" {
  value = aws_lb_target_group.aws_alb_tg.arn
  description = "ARN of Target Group"
}

output "ALB_DNS" {
  value = aws_lb.aws_alb.dns_name
  description = "The DNS name of the load balancer."
}