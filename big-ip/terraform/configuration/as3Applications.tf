# This resource will create and manage AS3 applications on BIG-IP from provided JSON declarations.

# HTTP declarations

data "as3_http_documents" "http-declarations" {
  pattern = "./files/applications/http-*.yaml"
  vars = {
  }
}

resource "bigip_as3" "http-declarations" {
  for_each  = toset(data.as3_path_documents.http-declarations.documents)
  json_body = each.value
}

# HTTPs declarations

data "as3_https_documents" "https-declarations" {
  pattern = "./files/applications/https-*.yaml"
  vars = {
  }
}

resource "bigip_as3" "https-declarations" {
  for_each  = toset(data.as3_path_documents.https-declarations.documents)
  json_body = each.value
}

# WIP declarations

data "as3_wip_documents" "wip-declarations" {
  pattern = "./files/applications/wip-*.yaml"
  vars = {
  }
}

resource "bigip_as3" "wip-declarations" {
  for_each  = toset(data.as3_path_documents.wip-declarations.documents)
  json_body = each.value
}

# TCP declarations

data "as3_tcp_documents" "tcp-declarations" {
  pattern = "./files/applications/tcp-*.yaml"
  vars = {
  }
}

resource "bigip_as3" "tcp-declarations" {
  for_each  = toset(data.as3_path_documents.tcp-declarations.documents)
  json_body = each.value
}

# UDP declarations

data "as3_udp_documents" "udp-declarations" {
  pattern = "./files/applications/udp-*.yaml"
  vars = {
  }
}

resource "bigip_as3" "udp-declarations" {
  for_each  = toset(data.as3_udp_documents.udp-declarations.documents)
  json_body = each.value
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