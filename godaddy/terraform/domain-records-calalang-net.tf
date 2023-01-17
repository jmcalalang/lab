resource "godaddy_domain_record" "domain-records-calalang-net" {
  domain = "calalang.net"

  # Records for Kubernetes

  record {
    name = "_acme-challenge.kubernetes"
    type = "CNAME"
    data = "8b15d782f9c4450fb7f49cf14ebdceb7.autocerts.ves.volterra.io"
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
    data = "468f3c5879314606bd61b17558398c26.autocerts.ves.volterra.io"
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
    data = "da972aad86bd4c2c934cad7f4db87dbf.autocerts.ves.volterra.io"
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
    data = "c5cc188069c0436b9639259e367626da.autocerts.ves.volterra.io"
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
    data = "b0431c75cfa14c6387a40d7bc60369c5.autocerts.ves.volterra.io"
    ttl  = 3600
  }

  record {
    name = "ingresslink"
    type = "CNAME"
    data = "ves-io-394bd2b7-1640-48ca-81b1-287ea6fe6402.ac.vh.ves.io"
    ttl  = 3600
  }

}