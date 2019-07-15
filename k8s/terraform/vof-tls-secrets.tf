data "template_file" "cert" {
  template = "${file("./secrets/ssl_andela_certificate.crt")}"
}

data "template_file" "key" {
  template = "${file("./secrets/ssl_andela_key.key")}"
}

resource "kubernetes_secret" "tls_secrets" {
  metadata {
    name         = "vof-tls-secret"
    namespace       = "${kubernetes_namespace.vof_tracker_namespace.id}"
  }
  type           = "kubernetes.io/tls"
  data {
    tls.crt      =  "${data.template_file.cert.rendered}"
    tls.key      =  "${data.template_file.key.rendered}"
  }
}
