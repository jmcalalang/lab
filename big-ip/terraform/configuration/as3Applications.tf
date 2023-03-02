# This resource will create and manage AS3 applications on BIG-IP from provided JSON declarations.

# HTTP declarations
resource "bigip_as3" "http-declarations" {
  for_each = fileset(path.module, "applications/http-**.json")
  as3_json = each.value
}

# HTTPs declarations
resource "bigip_as3" "https-declarations" {
  for_each = fileset(path.module, "applications/https-**.json")
  as3_json = each.value
}

# WIP declarations
resource "bigip_as3" "wip-declarations" {
  for_each   = fileset(path.module, "applications/wip-**.json")
  as3_json   = each.value
  depends_on = [bigip_as3.http-declarations]
}

# TCP declarations
resource "bigip_as3" "tcp-declarations" {
  for_each = fileset(path.module, "applications/tcp-**.json")
  as3_json = each.value
}

# UDP declarations
resource "bigip_as3" "udp-declarations" {
  for_each = fileset(path.module, "applications/udp-**.json")
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