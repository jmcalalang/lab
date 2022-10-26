# GoDaddy F5XC Challenge and Redirect

resource "godaddy_domain_record" "http-lb-bigip-calalang-net" {
  domain = "calalang.net"

  record {
    name = "_acme-challenge.bigip"
    type = "CNAME"
    data = "tbd.autocerts.ves.volterra.io."
    ttl  = 3600
  }

  record {
    name = "bigip"
    type = "CNAME"
    data = "ves-io-6b73677d-741b-4545-8189-2b982980a8da.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "apm"
    type = "CNAME"
    data = "ves-io-6b73677d-741b-4545-8189-2b982980a8da.ac.vh.ves.io"
    ttl  = 3600
  }

}