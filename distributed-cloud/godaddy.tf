resource "godaddy_domain_record" "calalang-net-domain-records" {
  domain = "calalang.net"

  # Records for Kubernetes

  record {
    name = "_acme-challenge.kubernetes"
    type = "CNAME"
    data = "4fcf0be6e9824222b2a440597d212e00.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.argo"
    type = "CNAME"
    data = "62454f842d6b4e629f0f718e0ead6d6c.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "kubernetes"
    type = "CNAME"
    data = "ves-io-68b8812f-df40-4984-bbe1-acf34195e4c3.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "argo"
    type = "CNAME"
    data = "ves-io-68b8812f-df40-4984-bbe1-acf34195e4c3.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for NGINX

  record {
    name = "_acme-challenge.nginx"
    type = "CNAME"
    data = "ae0fdf7d254743afa2cd2519a18b3fb1.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "nginx"
    type = "CNAME"
    data = "ves-io-b29d0700-76fb-4999-9967-b5f34e6f4ea7.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for BIG-IP

  record {
    name = "_acme-challenge.bigip"
    type = "CNAME"
    data = "8eb8b5ee4d2047c69cf036644b5f425f.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.apm"
    type = "CNAME"
    data = "5ffb1b7e9d764bf9a4cf9e12848f4607.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "bigip"
    type = "CNAME"
    data = "ves-io-b3274562-7ff0-4f49-bdb8-088d5efc1ff1.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "apm"
    type = "CNAME"
    data = "ves-io-b3274562-7ff0-4f49-bdb8-088d5efc1ff1.ac.vh.ves.io"
    ttl  = 3600
  }

}