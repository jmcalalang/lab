# This resource will create and manage AS3 applications on BIG-IP from provided JSON declarations.

# http nginx.calalang.net
resource "bigip_as3" "https-10-0-2-14-as3" {
  as3_json = file("${path.module}/applications/https-10-0-2-14-as3.json")
}

# wip nginx.calalang.net
resource "bigip_as3" "https-10-0-2-14-as3" {
  as3_json   = file("${path.module}/applications/wip-10-0-2-14-as3.json")
  depends_on = [bigip_as3.https-10-0-2-14-as3]
}