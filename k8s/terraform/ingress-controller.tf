data "template_file" "ingress" {
  template = "${file("${var.ingress_template_file}")}"

  vars {
    namespace                 = "${var.namespace}"
    regional_static_ip        = "${var.regional_static_ip}"
    vof_domain_name           = "${var.vof_domain_name}"
  }
}


resource "null_resource" "nginx_ingress" {
  triggers {
    ingress_file           = "${md5(data.template_file.ingress.rendered)}"
  }

  depends_on = [
    "kubernetes_secret.tls_secrets",
    "kubernetes_service.vof_tracker_service",
  ]

  provisioner "local-exec" {
    command = <<EOF
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
echo '${data.template_file.ingress.rendered}' | kubectl apply -f -
EOF
  }
}
