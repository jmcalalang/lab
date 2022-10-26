resource "godaddy_domain_record" "calalang-net-domain-records" {
  domain = "calalang.net"

  # Records for Kubernetes

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

  # Records for NGINX

  record {
    name = "_acme-challenge.nginx"
    type = "CNAME"
    data = "ae0fdf7d254743afa2cd2519a18b3fb1.autocerts.ves.volterra.io"
    # data = http-lb-nginx-calalang-net-auto_cert_info.value
    ttl = 3600
  }

  record {
    name = "nginx"
    type = "CNAME"
    data = "ves-io-b29d0700-76fb-4999-9967-b5f34e6f4ea7.ac.vh.ves.io"
    # data = http-lb-nginx-calalang-net-host_name.value
    ttl = 3600
  }

  # Records for BIG-IP

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