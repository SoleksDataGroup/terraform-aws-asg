// Module: aws/asg
// Description: AWS Autoscaling group
//

resource "aws_security_group" "asg-security-group" {
  name = "${var.name_prefix}-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each  = var.security_group_ingress
    content {
      self = lookup(ingress.value, "self", null)
      description = lookup(ingress.value, "description", null)
      protocol = lookup(ingress.value, "protocol", "-1")
      from_port = lookup(ingress.value, "from_port", -1)
      to_port = lookup(ingress.value, "to_port", -1)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", [])
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", [])
      prefix_list_ids =  lookup(ingress.value, "ip_list_ids", [])
      security_groups = lookup(ingress.value, "security_groups", [])
    }
  }
  
  dynamic "egress" {
    for_each  = var.security_group_egress
    content {
      self = lookup(egress.value, "self", null)
      description = lookup(egress.value, "description", null)
      protocol = lookup(egress.value, "protocol", "-1")
      from_port = lookup(egress.value, "from_port", -1)
      to_port = lookup(egress.value, "to_port", -1)
      cidr_blocks = lookup(egress.value, "cidr_blocks")
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", [])
      prefix_list_ids =  lookup(egress.value, "ip_list_ids", [])
      security_groups = lookup(egress.value, "security_groups", [])
    }
  }
}

data "aws_ami" "asg-ami" {
  name_regex = var.ami_name
  owners = ["self"]
}

resource "aws_launch_template" "asg-launch-tmpl" {
  name_prefix = "${var.name_prefix}"

  image_id =  data.aws_ami.asg-ami.id
  instance_type = var.instance_type

  block_device_mappings {
    device_name = var.block_device_name
    ebs {
      volume_type = var.block_device_type
      volume_size = var.block_device_size
      delete_on_termination = var.block_device_delete_on_termination
    }
  }
  iam_instance_profile {
    arn = "${var.instance_iam_profile_arn}"
  }

  user_data = var.user_data

  vpc_security_group_ids = [aws_security_group.asg-security-group.id]

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      {  "Name"  = format("%s", var.name_prefix)},
      var.tags
      )
  }

  monitoring {
    enabled = true
  }
}

resource "aws_autoscaling_group" "asg" {
  count = length(var.subnet_ids)
  name_prefix = "${var.name_prefix}"

  target_group_arns = var.target_group_arns

  desired_capacity   = var.group_desired_capacity
  min_size           = var.group_min_size
  max_size           = var.group_max_size

  vpc_zone_identifier = [var.subnet_ids[count.index]]

  dynamic "warm_pool" {
    for_each = var.warm_pool_enabled ? [1] : []
    content {
      pool_state                  = var.warm_pool_state
      min_size                    = var.warm_pool_min_size 
      max_group_prepared_capacity = var.warm_pool_prepared_capacity

      instance_reuse_policy {
        reuse_on_scale_in = var.reuse_on_scale_in
      }
    }
  }

  launch_template {
    id = aws_launch_template.asg-launch-tmpl.id
    version = "$Latest"
  }
}
