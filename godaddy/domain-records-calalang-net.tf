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
    data = "ves-io-01889f6c-b1d5-47f7-87ca-ade76526258a.ac.vh.ves.io"
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
    data = "ves-io-01889f6c-b1d5-47f7-87ca-ade76526258a.ac.vh.ves.io"
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
    data = "ves-io-01889f6c-b1d5-47f7-87ca-ade76526258a.ac.vh.ves.io"
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
    data = "ves-io-01889f6c-b1d5-47f7-87ca-ade76526258a.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for NGINX

  record {
    name = "_acme-challenge.nginx"
    type = "CNAME"
    data = "930da2fe978b473d9b0108d43f9c959c.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "nginx"
    type = "CNAME"
    data = "ves-io-79ef140b-19a7-4f1e-a7ca-8bd80ffb444c.ac.vh.ves.io"
    ttl  = 3600
  }

  # Records for BIG-IP

  record {
    name = "_acme-challenge.bigip"
    type = "CNAME"
    data = "c747e9c59c8f4d73b2f800f534444a96.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "bigip"
    type = "CNAME"
    data = "ves-io-394bd2b7-1640-48ca-81b1-287ea6fe6402.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.apm"
    type = "CNAME"
    data = "6414e82c6d984524872321145c2953a6.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "apm"
    type = "CNAME"
    data = "ves-io-394bd2b7-1640-48ca-81b1-287ea6fe6402.ac.vh.ves.io"
    ttl  = 3600
  }

  record {
    name = "_acme-challenge.ingresslink"
    type = "CNAME"
    data = "6414e82c6d984524872321145c2953a6.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "ingresslink"
    type = "CNAME"
    data = "ves-io-394bd2b7-1640-48ca-81b1-287ea6fe6402.ac.vh.ves.io"
    ttl  = 3600
  }

}