resource "godaddy_domain_record" "domain-records-calalang-net" {
  domain = "calalang.net"

  # Records for Kubernetes

  record {
    name = "_acme-challenge.kubernetes"
    type = "CNAME"
    data = "1d2849df3b0d4852b4de73e8c6e4bd6d.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "kubernetes"
    type = "CNAME"
    data = "ves-io-378639c7-5a35-49c4-a280-61f068f8a1ac.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.argo"
    type = "CNAME"
    data = "0c602a9c162940daa347dbcf7221d4b5.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "argo"
    type = "CNAME"
    data = "ves-io-378639c7-5a35-49c4-a280-61f068f8a1ac.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.nms"
    type = "CNAME"
    data = "f03a69faff5546f28575cde62cf1ba9c.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "nms"
    type = "CNAME"
    data = "ves-io-378639c7-5a35-49c4-a280-61f068f8a1ac.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.jwt.nms"
    type = "CNAME"
    data = "be3ebb0410e24a50953720de8e7f0641.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "jwt.nms"
    type = "CNAME"
    data = "ves-io-378639c7-5a35-49c4-a280-61f068f8a1ac.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for NGINX

  record {
    name = "_acme-challenge.nginx"
    type = "CNAME"
    data = "6f217aed38d3411999b55809432b53da.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "nginx"
    type = "CNAME"
    data = "ves-io-135930e9-1d5a-4969-98fc-7a97c7200036.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for BIG-IP

  record {
    name = "_acme-challenge.bigip"
    type = "CNAME"
    data = "2045bde44bd74251ac705adb881e464b.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "bigip"
    type = "CNAME"
    data = "ves-io-7f5e0391-5fb1-41e9-86d2-0977c413df7c.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.apm"
    type = "CNAME"
    data = "8991903199134d23985aeddd22b84197.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "apm"
    type = "CNAME"
    data = "ves-io-7f5e0391-5fb1-41e9-86d2-0977c413df7c.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.ingresslink"
    type = "CNAME"
    data = "52c84bf7c43b4cd2aa547a9be034fac6.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "ingresslink"
    type = "CNAME"
    data = "ves-io-7f5e0391-5fb1-41e9-86d2-0977c413df7c.ac.vh.ves.io"
    ttl  = 3600
  }

}