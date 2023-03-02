# This resource will create and manage AS3 applications on BIG-IP from provided JSON declarations.

# HTTP declarations
resource "bigip_as3" "http-declarations" {
  for_each = fileset(path.module, "applications/as3/http/**.json")
  as3_json = each.key
}

# HTTPs declarations
resource "bigip_as3" "https-declarations" {
  for_each = fileset(path.module, "/applications/as3/https/**.json")
  as3_json = each.key
}

# WIP declarations
resource "bigip_as3" "wip-declarations" {
  for_each   = fileset(path.module, "/applications/as3/wip/**.json")
  as3_json   = each.key
  depends_on = [bigip_as3.http-declarations, bigip_as3.https-declarations]
}

# TCP declarations
resource "bigip_as3" "tcp-declarations" {
  for_each = fileset(path.module, "/applications/as3/tcp/**.json")
  as3_json = each.key
}

# UDP declarations
resource "bigip_as3" "udp-declarations" {
  for_each = fileset(path.module, "/applications/as3/udp/**.json")
  as3_json = each.key
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