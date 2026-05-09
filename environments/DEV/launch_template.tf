
resource "aws_launch_template" "web_server" {
  name = var.name

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  image_id = var.ami_id
  instance_type = var.instance_type
  instance_initiated_shutdown_behavior = "terminate"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [aws_security_group.web_server_2_sg.id]
  }

  vpc_security_group_ids = [aws_security_group.web_server_2_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = local.common_tags
  }

  user_data = filebase64("../../scripts/user_data.sh")
}