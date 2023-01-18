# Loading from a file is the preferred method
resource "bigip_ltm_irule" "forward-nginx-org" {
  name  = "/Common/forward-nginx-org"
  irule = file("${path.module}/irules/forward-nginx-org.irule")
}