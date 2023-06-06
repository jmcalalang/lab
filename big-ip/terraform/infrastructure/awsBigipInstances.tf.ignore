################################# AWS BIG-IP Instances #################################

## Shared Objects

## AWS Network Objects

resource "aws_eip" "eip_mgmt_az1" {
  count             = sum([var.big_ip_per_az_count])
  vpc               = true
  network_interface = aws_network_interface.nic-management-az1[count.index].id
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_network_interface" "nic-management-az1" {
  count           = sum([var.big_ip_per_az_count])
  subnet_id       = var.existing_subnet_az1_management_id
  security_groups = [aws_security_group.big_ip_mgmt_security_group.id]
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_eip" "eip_external_vip_01_az1" {
  count                     = sum([var.big_ip_per_az_count])
  network_interface         = aws_network_interface.nic-external-az1[count.index].id
  associate_with_private_ip = element(compact([for x in tolist(aws_network_interface.nic-external-az1[count.index].private_ip_list) : x == aws_network_interface.nic-external-az1[count.index].private_ip ? "" : x]), 0)
  vpc                       = true
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_network_interface" "nic-external-az1" {
  count             = sum([var.big_ip_per_az_count])
  subnet_id         = var.existing_subnet_az1_external_id
  private_ips_count = var.external_secondary_ip_count
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_network_interface" "nic-internal-az1" {
  count             = sum([var.big_ip_per_az_count])
  subnet_id         = var.existing_subnet_az1_internal_id
  private_ips_count = var.internal_secondary_ip_count
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_eip" "eip_mgmt_az2" {
  count             = sum([var.big_ip_per_az_count])
  vpc               = true
  network_interface = aws_network_interface.nic-management-az2[count.index].id
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_network_interface" "nic-management-az2" {
  count           = sum([var.big_ip_per_az_count])
  subnet_id       = var.existing_subnet_az2_management_id
  security_groups = [aws_security_group.big_ip_mgmt_security_group.id]
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_eip" "eip_external_vip_01_az2" {
  count                     = sum([var.big_ip_per_az_count])
  network_interface         = aws_network_interface.nic-external-az2[count.index].id
  associate_with_private_ip = element(compact([for x in tolist(aws_network_interface.nic-external-az2[count.index].private_ip_list) : x == aws_network_interface.nic-external-az2[count.index].private_ip ? "" : x]), 0)
  vpc                       = true
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_network_interface" "nic-external-az2" {
  count             = sum([var.big_ip_per_az_count])
  subnet_id         = var.existing_subnet_az2_external_id
  private_ips_count = var.external_secondary_ip_count
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_network_interface" "nic-internal-az2" {
  count             = sum([var.big_ip_per_az_count])
  subnet_id         = var.existing_subnet_az2_internal_id
  private_ips_count = var.internal_secondary_ip_count
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_security_group" "big_ip_mgmt_security_group" {
  description = "Management interface security rules"
  vpc_id      = var.vpc_id
  # Allows SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = 6
    cidr_blocks = var.allowed_ips
  }
  # Allows GUI access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = 6
    cidr_blocks = var.allowed_ips
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_security_group" "big_ip_external_security_group" {
  description = "External interface security rules"
  vpc_id      = var.vpc_id
  # Allows HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = 6
    cidr_blocks = var.allowed_ips
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

## Identity and Access Management

resource "aws_iam_role" "main" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "BigIpPolicy" {
  role   = aws_iam_role.main.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeAddresses",
            "ec2:AssociateAddress",
            "ec2:DisassociateAddress",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribeNetworkInterfaceAttribute",
            "ec2:DescribeRouteTables",
            "ec2:ReplaceRoute",
            "ec2:CreateRoute",
            "ec2:assignprivateipaddresses",
            "sts:AssumeRole",
            "s3:ListAllMyBuckets"
        ],
        "Resource": [
            "*"
        ],
        "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  role = aws_iam_role.main.id
}

## Instances

data "aws_ami" "f5_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "description"
    values = [var.big_ip_ami]
  }
}

resource "aws_instance" "big-ip-az1" {
  count                = sum([var.big_ip_per_az_count])
  ami                  = data.aws_ami.f5_ami.id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  network_interface {
    network_interface_id = aws_network_interface.nic-management-az1[count.index].id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.nic-internal-az1[count.index].id
    device_index         = 1
  }
  network_interface {
    network_interface_id = aws_network_interface.nic-external-az1[count.index].id
    device_index         = 2
  }
  user_data_base64 = base64encode(templatefile("${path.module}/files/aws-bootstrap-big-ip-instances.tpl", {
    package_url = var.bigip_runtime_init_package_url
  }))
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_instance" "big-ip-az2" {
  count                = sum([var.big_ip_per_az_count])
  ami                  = data.aws_ami.f5_ami.id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  network_interface {
    network_interface_id = aws_network_interface.nic-management-az2[count.index].id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.nic-internal-az2[count.index].id
    device_index         = 1
  }
  network_interface {
    network_interface_id = aws_network_interface.nic-external-az2[count.index].id
    device_index         = 2
  }

  user_data_base64 = base64encode(templatefile("${path.module}/files/aws-bootstrap-big-ip-instances.tpl", {
    package_url = var.bigip_runtime_init_package_url
  }))
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

## Wait for BIG-IP
resource "time_sleep" "aws_bigip_ready" {
  depends_on      = [aws_instance.big-ip-az1, aws_instance.big-ip-az2]
  create_duration = var.bigip_ready
}