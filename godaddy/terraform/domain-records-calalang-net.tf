resource "godaddy_domain_record" "domain-records-calalang-net" {
  domain = "calalang.net"

  # Records for Kubernetes

  record {
    name = "_acme-challenge.kubernetes"
    type = "CNAME"
    data = "a5bd2c7550b9469280e6a7fa612ad638.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "kubernetes"
    type = "CNAME"
    data = "ves-io-f4e9697e-fe31-487c-a25f-30ecacfebea8.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.argo"
    type = "CNAME"
    data = "89757a8354284253b6521771401a9bc3.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "argo"
    type = "CNAME"
    data = "ves-io-f4e9697e-fe31-487c-a25f-30ecacfebea8.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.nms"
    type = "CNAME"
    data = "884f4b2a586b45538d4a7d6a26f2232d.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "nms"
    type = "CNAME"
    data = "ves-io-f4e9697e-fe31-487c-a25f-30ecacfebea8.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.jwt.nms"
    type = "CNAME"
    data = "5449c620dc644f1eb3e8377eabd3f87b.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "jwt.nms"
    type = "CNAME"
    data = "ves-io-f4e9697e-fe31-487c-a25f-30ecacfebea8.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for NGINX

  record {
    name = "_acme-challenge.nginx"
    type = "CNAME"
    data = "6e0c898fbe0c4d81a8987cdc0055c608.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "nginx"
    type = "CNAME"
    data = "ves-io-64eec98a-0583-4f91-829f-79f6773d1e7e.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for BIG-IP

  record {
    name = "_acme-challenge.bigip"
    type = "CNAME"
    data = "22a5cbc1825c44f8bdf48e8f2d6338e6.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "bigip"
    type = "CNAME"
    data = "ves-io-63ab01f1-be0f-434f-92ed-b59df9ece6df.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.apm"
    type = "CNAME"
    data = "08052900b5bf4aa8a67d995c6134a6d5.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "apm"
    type = "CNAME"
    data = "ves-io-63ab01f1-be0f-434f-92ed-b59df9ece6df.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.ingresslink"
    type = "CNAME"
    data = "d33dd1a37d004f048948e46f53850c26.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "ingresslink"
    type = "CNAME"
    data = "ves-io-63ab01f1-be0f-434f-92ed-b59df9ece6df.ac.vh.ves.io"
    ttl  = 3600
  }

}