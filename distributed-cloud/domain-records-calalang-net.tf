resource "godaddy_domain_record" "domain-records-calalang-net" {
  domain = "calalang.net"

  # Records for Kubernetes

  record {
    name = "_acme-challenge.kubernetes"
    type = "CNAME"
    data = "05da1338ae7b4eebb7ac51f5b1ae5364.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "kubernetes"
    type = "CNAME"
    data = "ves-io-25df1b5c-b4b2-4cec-9032-c770713a792d.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.argo"
    type = "CNAME"
    data = "8a5ddd6e2b004e4991f15538dda6bbb8.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "argo"
    type = "CNAME"
    data = "ves-io-25df1b5c-b4b2-4cec-9032-c770713a792d.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.nms"
    type = "CNAME"
    data = "3cec1a0623c34897bbd743e9c67144bb.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "nms"
    type = "CNAME"
    data = "ves-io-25df1b5c-b4b2-4cec-9032-c770713a792d.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.jwt.nms"
    type = "CNAME"
    data = "fca747fe48e94d12b0b9082976e03e0a.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "jwt.nms"
    type = "CNAME"
    data = "ves-io-25df1b5c-b4b2-4cec-9032-c770713a792d.ac.vh.ves.io"
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
    data = "ves-io-35db3d1d-359f-4c11-994d-04bfce9746be.ac.vh.ves.io"
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
    name = "bigip"
    type = "CNAME"
    data = "ves-io-086b7aaa-673e-46c8-8181-3580e0ff066e.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.apm"
    type = "CNAME"
    data = "5ffb1b7e9d764bf9a4cf9e12848f4607.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "apm"
    type = "CNAME"
    data = "ves-io-086b7aaa-673e-46c8-8181-3580e0ff066e.ac.vh.ves.io"
    ttl  = 3600
  }

}