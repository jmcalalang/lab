# This resource will create and manage AS3 applications on BIG-IP from provided JSON declarations.

# HTTP declarations
resource "bigip_as3" "http-declarations" {
  for_each        = fileset(path.module, "applications/as3/http/**.json")
  as3_json        = file("${path.module}/${each.key}")
  ignore_metadata = true
}

# HTTPs declarations
resource "bigip_as3" "https-declarations" {
  for_each        = fileset(path.module, "applications/as3/https/**.json")
  as3_json        = file("${path.module}/${each.key}")
  ignore_metadata = true
}

# WIP declarations
resource "bigip_as3" "wip-declarations" {
  for_each        = fileset(path.module, "applications/as3/wip/**.json")
  as3_json        = file("${path.module}/${each.key}")
  ignore_metadata = true
  depends_on      = [bigip_as3.http-declarations, bigip_as3.https-declarations]
}

# TCP declarations
resource "bigip_as3" "tcp-declarations" {
  for_each        = fileset(path.module, "applications/as3/tcp/**.json")
  as3_json        = file("${path.module}/${each.key}")
  ignore_metadata = true
}

# UDP declarations
resource "bigip_as3" "udp-declarations" {
  for_each        = fileset(path.module, "applications/as3/udp/**.json")
  as3_json        = file("${path.module}/${each.key}")
  ignore_metadata = true
}