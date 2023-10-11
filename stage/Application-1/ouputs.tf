############## 작업순서 : ALB -> ASG ############## 

output "ALB_TG" {
  value       = module.stage_alb.ALB_TG
  description = "ARN of Target Group"
}

output "ALB_DNS" {
  value       = module.stage_alb.ALB_DNS
  description = "The DNS name of the load balancer."
}