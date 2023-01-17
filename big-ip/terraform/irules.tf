# Loading from a file is the preferred method
resource "bigip_ltm_irule" "forward-nginxCalalangNet-vs" {
  name  = "/Common/forward-nginxCalalangNet-vs.irule"
  irule = file("${path.module}/irules/forward-nginxCalalangNet-vs.irule")
}