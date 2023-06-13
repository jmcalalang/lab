################################# AWS Networking #################################

## AWS Virtual Private Cloud DHCP Options
resource "aws_vpc_dhcp_options" "aws-default" {
  domain_name         = "${var.aws_location}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_vpc_dhcp_options_association" "aws-default" {
  vpc_id          = aws_vpc.aws-10-0-0-0-16-vnet.id
  dhcp_options_id = aws_vpc_dhcp_options.aws-default.id
}

## AWS Virtual Private Cloud
resource "aws_vpc" "aws-10-0-0-0-16-vnet" {
  cidr_block = "10.0.0.0/16"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

## AWS Virtual Private Cloud Subnets
resource "aws_subnet" "management-az1" {
  availability_zone = "us-west-2a"
  vpc_id            = aws_vpc.aws-10-0-0-0-16-vnet.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_subnet" "management-az2" {
  availability_zone = "us-west-2b"
  vpc_id            = aws_vpc.aws-10-0-0-0-16-vnet.id
  cidr_block        = "10.0.11.0/24"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_subnet" "external-az1" {
  availability_zone = "us-west-2a"
  vpc_id            = aws_vpc.aws-10-0-0-0-16-vnet.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_subnet" "external-az2" {
  availability_zone = "us-west-2b"
  vpc_id            = aws_vpc.aws-10-0-0-0-16-vnet.id
  cidr_block        = "10.0.22.0/24"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_subnet" "internal-az1" {
  availability_zone = "us-west-2a"
  vpc_id            = aws_vpc.aws-10-0-0-0-16-vnet.id
  cidr_block        = "10.0.3.0/24"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_subnet" "internal-az2" {
  availability_zone = "us-west-2b"
  vpc_id            = aws_vpc.aws-10-0-0-0-16-vnet.id
  cidr_block        = "10.0.33.0/24"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

## AWS Network Security Groups

resource "aws_network_acl" "management-nsg" {
  vpc_id = aws_vpc.aws-10-0-0-0-16-vnet.id
  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.aws-10-0-0-0-16-vnet.cidr_block
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.aws-10-0-0-0-16-vnet.cidr_block
    from_port  = 0
    to_port    = 0
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_network_acl_association" "management-az1-nsg" {
  network_acl_id = aws_network_acl.management-nsg.id
  subnet_id      = aws_subnet.management-az1.id
}

resource "aws_network_acl_association" "management-az2-nsg" {
  network_acl_id = aws_network_acl.management-nsg.id
  subnet_id      = aws_subnet.management-az2.id
}

resource "aws_network_acl" "external-nsg" {
  vpc_id = aws_vpc.aws-10-0-0-0-16-vnet.id
  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.aws-10-0-0-0-16-vnet.cidr_block
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.aws-10-0-0-0-16-vnet.cidr_block
    from_port  = 0
    to_port    = 0
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_network_acl_association" "external-az1-nsg" {
  network_acl_id = aws_network_acl.external-nsg.id
  subnet_id      = aws_subnet.external-az1.id
}

resource "aws_network_acl_association" "external-az2-nsg" {
  network_acl_id = aws_network_acl.external-nsg.id
  subnet_id      = aws_subnet.external-az2.id
}

resource "aws_network_acl" "internal-nsg" {
  vpc_id = aws_vpc.aws-10-0-0-0-16-vnet.id
  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.aws-10-0-0-0-16-vnet.cidr_block
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.aws-10-0-0-0-16-vnet.cidr_block
    from_port  = 0
    to_port    = 0
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_network_acl_association" "internal-az1-nsg" {
  network_acl_id = aws_network_acl.internal-nsg.id
  subnet_id      = aws_subnet.internal-az1.id
}

resource "aws_network_acl_association" "internal-az2-nsg" {
  network_acl_id = aws_network_acl.internal-nsg.id
  subnet_id      = aws_subnet.internal-az2.id
}

## AWS Network Route Table

resource "aws_route_table" "management" {
  vpc_id = aws_vpc.aws-10-0-0-0-16-vnet.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-10-0-0-0-16-vnet-igw.id
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_route_table_association" "management-az1-rt" {
  subnet_id      = aws_subnet.management-az1.id
  route_table_id = aws_route_table.management.id
}

resource "aws_route_table_association" "management-az2-rt" {
  subnet_id      = aws_subnet.management-az2.id
  route_table_id = aws_route_table.management.id
}

resource "aws_route_table" "external" {
  vpc_id = aws_vpc.aws-10-0-0-0-16-vnet.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-10-0-0-0-16-vnet-igw.id
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_route_table_association" "external-az1-rt" {
  subnet_id      = aws_subnet.external-az1.id
  route_table_id = aws_route_table.external.id
}

resource "aws_route_table_association" "external-az2-rt" {
  subnet_id      = aws_subnet.external-az2.id
  route_table_id = aws_route_table.external.id
}

resource "aws_route_table" "internal-az1" {
  vpc_id = aws_vpc.aws-10-0-0-0-16-vnet.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.internal-az1-ng.id
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_route_table" "internal-az2" {
  vpc_id = aws_vpc.aws-10-0-0-0-16-vnet.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.internal-az2-ng.id
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_route_table_association" "internal-az1-rt" {
  subnet_id      = aws_subnet.internal-az1.id
  route_table_id = aws_route_table.internal-az1.id
}

resource "aws_route_table_association" "internal-az2-rt" {
  subnet_id      = aws_subnet.internal-az2.id
  route_table_id = aws_route_table.internal-az2.id
}

## AWS Nat Gateway

resource "aws_eip" "internal-az1-ng-eip" {
  domain = "vpc"

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.aws-10-0-0-0-16-vnet-igw]
}

resource "aws_nat_gateway" "internal-az1-ng" {
  allocation_id = aws_eip.internal-az1-ng-eip.id
  subnet_id     = aws_subnet.internal-az1.id
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.aws-10-0-0-0-16-vnet-igw]
}

resource "aws_eip" "internal-az2-ng-eip" {
  domain = "vpc"

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.aws-10-0-0-0-16-vnet-igw]
}

resource "aws_nat_gateway" "internal-az2-ng" {
  allocation_id = aws_eip.internal-az2-ng-eip.id
  subnet_id     = aws_subnet.internal-az2.id
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.aws-10-0-0-0-16-vnet-igw]
}

## AWS Internet Gateway

resource "aws_internet_gateway" "aws-10-0-0-0-16-vnet-igw" {
  vpc_id = aws_vpc.aws-10-0-0-0-16-vnet.id
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}