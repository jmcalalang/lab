# This resource will create and manage AS3 applications on BIG-IP from provided JSON declarations.

# HTTP declarations
resource "bigip_as3" "http-declarations" {
  for_each        = fileset(path.module, "applications/as3/http/**.tpl")
  as3_json        = templatefile("${path.module}/${each.key}", { subscriptionId = var.ARM_SUBSCRIPTION_ID })
  ignore_metadata = true
}

# HTTPs declarations
resource "bigip_as3" "https-declarations" {
  for_each        = fileset(path.module, "applications/as3/https/**.tpl")
  as3_json        = templatefile("${path.module}/${each.key}", { as3-version = var.as3-version })
  ignore_metadata = true
}

# WIP declarations
resource "bigip_as3" "wip-declarations" {
  for_each        = fileset(path.module, "applications/as3/wip/**.tpl")
  as3_json        = templatefile("${path.module}/${each.key}", { subscriptionId = var.ARM_SUBSCRIPTION_ID })
  ignore_metadata = true
  depends_on      = [bigip_as3.http-declarations, bigip_as3.https-declarations]
}

# TCP declarations
resource "bigip_as3" "tcp-declarations" {
  for_each        = fileset(path.module, "applications/as3/tcp/**.tpl")
  as3_json        = templatefile("${path.module}/${each.key}", { subscriptionId = var.ARM_SUBSCRIPTION_ID })
  ignore_metadata = true
}

# UDP declarations
resource "bigip_as3" "udp-declarations" {
  for_each        = fileset(path.module, "applications/as3/udp/**.tpl")
  as3_json        = templatefile("${path.module}/${each.key}", { subscriptionId = var.ARM_SUBSCRIPTION_ID })
  ignore_metadata = true
}

# Pool declarations
resource "bigip_as3" "pool-declarations" {
  for_each        = fileset(path.module, "applications/as3/pool/**.tpl")
  as3_json        = templatefile("${path.module}/${each.key}", { subscriptionId = var.ARM_SUBSCRIPTION_ID })
  ignore_metadata = true
}