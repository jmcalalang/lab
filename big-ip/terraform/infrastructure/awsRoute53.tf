resource "aws_route53_zone" "route53_zone" {
  name = var.route53_zone
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_route53_health_check" "route53_health_check" {
  fqdn              = "${var.route53_multivalue_name}.${var.route53_zone}"
  port              = 443
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "aws_route53_record" "eip_external_vip_01_az1" {
  count                            = sum([var.big_ip_per_az_count])
  allow_overwrite                  = true
  name                             = var.route53_multivalue_name
  ttl                              = 300
  type                             = "A"
  set_identifier                   = aws_eip.eip_external_vip_01_az1[count.index].id
  multivalue_answer_routing_policy = true
  health_check_id                  = aws_route53_health_check.route53_health_check.id
  zone_id                          = aws_route53_zone.route53_zone.zone_id
  records = [
    aws_eip.eip_external_vip_01_az1[count.index].public_ip
  ]
}

resource "aws_route53_record" "eip_external_vip_01_az2" {
  count                            = sum([var.big_ip_per_az_count])
  allow_overwrite                  = true
  name                             = var.route53_multivalue_name
  ttl                              = 300
  type                             = "A"
  set_identifier                   = aws_eip.eip_external_vip_01_az2[count.index].id
  multivalue_answer_routing_policy = true
  health_check_id                  = aws_route53_health_check.route53_health_check.id
  zone_id                          = aws_route53_zone.route53_zone.zone_id
  records = [
    aws_eip.eip_external_vip_01_az2[count.index].public_ip
  ]
}