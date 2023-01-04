data "bigip_ltm_irule" "_sys_https_redirect" {
  name      = "_sys_https_redirect"
  partition = "Common"
}


output "_sys_https_redirect" {
  value = data.bigip_ltm_irule._sys_https_redirect.irule
}