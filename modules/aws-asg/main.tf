############## 작업순서 : ALB -> ASG ############## 

// ASG (Auto Scaling Group) 

# 시작 템플릿
resource "aws_launch_configuration" "aws_asg_launch" {
  name = "${var.name}-asg-launch"
  image_id        = "ami-0ea4d4b8dc1e46212"
  instance_type   = var.instance_type
  security_groups = [var.SSH_SG_id, var.HTTP_HTTPS_SG_id]

  user_data = <<-EOF
    #!/bin/bash
    yum -y update
    yum -y install httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "DB Endpoint : ${data.terraform_remote_state.rds_remote_data.outputs.rds_instance_address}" > /var/www/html/index.html
    echo "DB Port : ${data.terraform_remote_state.rds_remote_data.outputs.rds_instance_port}" > /var/www/html/index.html
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

# 오토스케일링 그룹
resource "aws_autoscaling_group" "aws_asg" {
  name = "${var.name}-asg"
  launch_configuration = aws_launch_configuration.aws_asg_launch.name
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.private_subnets

  target_group_arns = [data.terraform_remote_state.alb_remote_data.outputs.ALB_TG]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.name}-Terraform_Instance"
    propagate_at_launch = true
  }
}
