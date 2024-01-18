resource "godaddy_domain_record" "domain-records-calalang-net" {
  domain = "calalang.net"

  # Records for Wildcard

  record {
    name = "_acme-challenge"
    type = var.record-type-txt
    data = "-psufVD6PY8q_Gf3K_s8iuVNG5RnBjcvX0XqV4wZMJE"
    ttl  = var.ttl
  }

  # Records for Discovery

  record {
    name = "discovery"
    type = var.record-type-cname
    data = var.http-lb-discovery-ves-hostname
    ttl  = var.ttl
  }

  # Records for JWT

  record {
    name = "jwt"
    type = var.record-type-cname
    data = var.http-lb-kubernetes-ves-hostname
    ttl  = var.ttl
  }

  # Records for Kubernetes

  record {
    name = "_acme-challenge.kubernetes"
    type = var.record-type-cname
    data = "8765fe94740a457f96ce4d46132963dd.autocerts.ves.volterra.io"
    ttl  = var.ttl
  }

  record {
    name = "kubernetes"
    type = var.record-type-cname
    data = var.http-lb-kubernetes-ves-hostname
    ttl  = var.ttl
  }

  record {
    name = "_acme-challenge.argo"
    type = var.record-type-cname
    data = "4d628d8732d7409b887a4a5e33c71a91.autocerts.ves.volterra.io"
    ttl  = var.ttl
  }

  record {
    name = "argo"
    type = var.record-type-cname
    data = var.http-lb-kubernetes-ves-hostname
    ttl  = var.ttl
  }

  record {
    name = "_acme-challenge.nms"
    type = var.record-type-cname
    data = "e979678f91c74c5f83d909055bb970f7.autocerts.ves.volterra.io"
    ttl  = var.ttl
  }

  record {
    name = "nms"
    type = var.record-type-cname
    data = var.http-lb-kubernetes-ves-hostname
    ttl  = var.ttl
  }

  record {
    name = "_acme-challenge.jwt.nms"
    type = var.record-type-cname
    data = "77fcf4a2b99f4acfa91a9923ce33a594.autocerts.ves.volterra.io"
    ttl  = var.ttl
  }

  record {
    name = "jwt.nms"
    type = var.record-type-cname
    data = var.http-lb-kubernetes-ves-hostname
    ttl  = var.ttl
  }

  # Records for NGINX

  record {
    name = "nginx"
    type = var.record-type-cname
    data = var.http-lb-nginx-ves-hostname
    ttl  = var.ttl
  }

  # Records for BIG-IP

  record {
    name = "apm"
    type = "A"
    data = "20.69.161.167"
    ttl  = var.ttl
  }

  record {
    name = "_acme-challenge.bigip"
    type = var.record-type-cname
    data = "3a038a23d2d94ab48964811d58ffbfeb.autocerts.ves.volterra.io"
    ttl  = var.ttl
  }

  record {
    name = "bigip"
    type = var.record-type-cname
    data = var.http-lb-big-ip-ves-hostname
    ttl  = var.ttl
  }

  record {
    name = "_acme-challenge.ingresslink"
    type = var.record-type-cname
    data = "1d2f586b1fbf4b1b9507fcedd83278a7.autocerts.ves.volterra.io"
    ttl  = var.ttl
  }

  record {
    name = "ingresslink"
    type = var.record-type-cname
    data = var.http-lb-big-ip-ves-hostname
    ttl  = var.ttl
  }

}
