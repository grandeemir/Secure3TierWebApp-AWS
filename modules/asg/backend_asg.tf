
resource "aws_launch_template" "backend_server" {
  name = "${var.name}-backend-launch-template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  image_id                             = var.ami_id
  instance_type                        = var.instance_type
  instance_initiated_shutdown_behavior = "terminate"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  key_name = null

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    description                 = "eth0"
    device_index                = 0
    security_groups             = [var.backend_servers_sg_id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }

  user_data = base64encode(templatefile("../../scripts/user_data_backend.sh", {
    db_host        = var.db_address
    db_password    = var.db_password
    db_user        = "admin"
    db_name        = "ToDoAppDB"
    redis_endpoint = var.redis_endpoint
  }))
}

resource "aws_autoscaling_group" "backend_asg" {
  name             = "${var.name}-backend-asg"
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity

  target_group_arns = [var.backend_target_group_arn]

  launch_template {
    id      = aws_launch_template.backend_server.id
    version = "$Latest"
  }

  vpc_zone_identifier       = var.private_subnets
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.name}-backend-instance"
    propagate_at_launch = true
  }

}