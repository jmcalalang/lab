## This resource will create and manage FAST applications on BIG-IP from provided JSON declaration.

resource "bigip_fast_application" "calalangDomainController" {
  fast_json = file("calalangDomainController.fast")
}