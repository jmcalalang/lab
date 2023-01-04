resource "bigip_ltm_irule" "terraform-irule" {
  name  = "/Common/terraform-irule"
  irule = <<EOF
when CLIENT_ACCEPTED {
     log local0. "terraform"
   }
EOF
}