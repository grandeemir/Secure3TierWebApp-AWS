resource "aws_launch_template" "web_server" {
  name = var.name

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  image_id                             = var.ami_id
  instance_type                        = var.instance_type
  instance_initiated_shutdown_behavior = "terminate"
  key_name = null

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    description                 = "eth0"
    device_index                = 0
    security_groups             = [var.web_sg]
  }

  tag_specifications {
    resource_type = "instance"

    tags = local.common_tags
  }

 user_data = base64encode(templatefile("../../scripts/user_data_AL2023.sh", {
    db_host     = var.db_address
    db_password = var.db_password
    db_user     = "admin"
    db_name     = "ToDoAppDB"
  }))

}

resource "aws_autoscaling_group" "web_asg" {
  name                      = var.name
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity

  target_group_arns = [var.target_group_arn]
 
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }
  
  vpc_zone_identifier       = var.public_subnets
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.name}-instance"
    propagate_at_launch = true
  }
  
}