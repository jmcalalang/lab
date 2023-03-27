resource "godaddy_domain_record" "domain-records-calalang-net" {
  domain = "calalang.net"

  # Records for Kubernetes

  record {
    name = "_acme-challenge.kubernetes"
    type = "CNAME"
    data = "1874753db2e34be5a4087a1c68ac436a.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "kubernetes"
    type = "CNAME"
    data = "ves-io-7e9a0cf1-ab2a-496f-bd45-4b1cdaaf258d.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.argo"
    type = "CNAME"
    data = "16e96b012388475e984aeaaae866b195.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "argo"
    type = "CNAME"
    data = "ves-io-7e9a0cf1-ab2a-496f-bd45-4b1cdaaf258d.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.nms"
    type = "CNAME"
    data = "e71fe4ab75b743168f02da479973570e.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "nms"
    type = "CNAME"
    data = "ves-io-7e9a0cf1-ab2a-496f-bd45-4b1cdaaf258d.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.jwt.nms"
    type = "CNAME"
    data = "b33e7ccd5258423e8d6f4c8189c1ffaf.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "jwt.nms"
    type = "CNAME"
    data = "ves-io-7e9a0cf1-ab2a-496f-bd45-4b1cdaaf258d.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for NGINX

  record {
    name = "_acme-challenge.nginx"
    type = "CNAME"
    data = "c64a346eb873471d8c9a7c779e57914b.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "nginx"
    type = "CNAME"
    data = "ves-io-36af6783-92cf-415f-b2ac-f2ac5c41cbf8.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for BIG-IP

  record {
    name = "_acme-challenge.bigip"
    type = "CNAME"
    data = "434db158db7e4a53a52111b26284c59c.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "bigip"
    type = "CNAME"
    data = "ves-io-723f7c87-b075-4c06-96e4-4e3cdedb4b97.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.apm"
    type = "CNAME"
    data = "50115edde1d1446d8b5bd21a57973e45.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "apm"
    type = "CNAME"
    data = "ves-io-723f7c87-b075-4c06-96e4-4e3cdedb4b97.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.ingresslink"
    type = "CNAME"
    data = "9fed3193e074427994483d999ef9e008.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "ingresslink"
    type = "CNAME"
    data = "ves-io-723f7c87-b075-4c06-96e4-4e3cdedb4b97.ac.vh.ves.io"
    ttl  = 3600
  }

}