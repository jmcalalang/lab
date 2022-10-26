# GoDaddy F5XC Challenge and Redirect

resource "godaddy_domain_record" "http-lb-kubernetes-calalang-net" {
  domain = "calalang.net"

  record {
    name = "_acme-challenge.kubernetes"
    type = "CNAME"
    data = "tbd.autocerts.ves.volterra.io."
    ttl  = 3600
  }

  record {
    name = "kubernetes"
    type = "CNAME"
    data = "ves-io-c296fefe-3200-4d90-8388-6f27391aa62f.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "argo"
    type = "CNAME"
    data = "ves-io-c296fefe-3200-4d90-8388-6f27391aa62f.ac.vh.ves.io"
    ttl  = 3600
  }

}