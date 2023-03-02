# This resource will create and manage AS3 applications on BIG-IP from provided JSON declarations.

# HTTP declarations
data "template_file" "http-declarations" {
  template = file("${path.module}/applications/http-*.json")
  vars = {
  }
}

resource "bigip_as3" "http-declarations" {
  for_each = toset(data.template_file.http-declarations.documents)
  as3_json = each.value
}

# HTTPs declarations
data "template_file" "https-declarations" {
  template = file("${path.module}/applications/https-*.json")
  vars = {
  }
}

resource "bigip_as3" "https-declarations" {
  for_each = toset(data.template_file.https-declarations.documents)
  as3_json = each.value
}

# WIP declarations
data "template_file" "wip-declarations" {
  template   = file("${path.module}/applications/wip-*.json")
  depends_on = [bigip_as3.http-declarations, bigip_as3.https-declarations]
  vars = {
  }
}

resource "bigip_as3" "wip-declarations" {
  for_each = toset(data.template_file.wip-declarations.documents)
  as3_json = each.value
}

# TCP declarations
data "template_file" "tcp-declarations" {
  template = file("${path.module}/applications/tcp-*.json")
  vars = {
  }
}

resource "bigip_as3" "tcp-declarations" {
  for_each = toset(data.template_file.tcp-declarations.documents)
  as3_json = each.value
}

# UDP declarations
data "template_file" "udp-declarations" {
  template = file("${path.module}/applications/udp-*.json")
  vars = {
  }
}

resource "bigip_as3" "udp-declarations" {
  for_each = toset(data.template_file.udp-declarations.documents)
  as3_json = each.value
}

## http bigip.calalang.net
#resource "bigip_as3" "https-10-0-2-6-as3" {
#  as3_json = file("${path.module}/applications/https-10-0-2-6-as3.json")
#}
## wip bigip.calalang.net
#resource "bigip_as3" "wip-10-0-2-6-as3" {
#  as3_json   = file("${path.module}/applications/wip-10-0-2-6-as3.json")
#  depends_on = [bigip_as3.https-10-0-2-6-as3]
#}