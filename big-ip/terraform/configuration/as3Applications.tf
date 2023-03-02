# This resource will create and manage AS3 applications on BIG-IP from provided JSON declarations.

# HTTP declarations
resource "bigip_as3" "http-declarations" {
  as3_json = fileset(path.module, "applications/as3/http/**.json")
}

# HTTPs declarations
resource "bigip_as3" "https-declarations" {
  as3_json = fileset(path.module, "/applications/as3/https/**.json")
}

# WIP declarations
resource "bigip_as3" "wip-declarations" {
  as3_json   = fileset(path.module, "/applications/as3/wip/**.json")
  depends_on = [bigip_as3.http-declarations, bigip_as3.https-declarations]
}

# TCP declarations
resource "bigip_as3" "tcp-declarations" {
  as3_json = fileset(path.module, "/applications/as3/tcp/**.json")
}

# UDP declarations
resource "bigip_as3" "udp-declarations" {
  as3_json = fileset(path.module, "/applications/as3/udp/**.json")
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