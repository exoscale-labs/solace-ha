provider "exoscale" {
  alias  = "dns"
  key    = "${var.exoscale_dns_api_key}"
  secret = "${var.exoscale_dns_secret_key}"
}
resource "null_resource" "getsvcip" {
  provisioner "local-exec" {
    command      = "sleep 5; ingress_ips.txt; until ! kubectl --kubeconfig kube_config get services/solace-ha-exoscale-pubsubplus|grep pending;do echo still pending;sleep 5;done; kubectl --kubeconfig kube_config get services/solace-ha-exoscale-pubsubplus|grep solace-ha-exoscale-pubsubplus|awk '{print $4}' > ingress_ips.txt"
  }
  depends_on = [
    resource.null_resource.ha-exoscale # optional if need to fit this in with other preceding resource
  ]
}

data "local_file" "ingress-ip" {
    filename = "ingress_ips.txt"
  depends_on = [
    resource.null_resource.getsvcip
  ]
}

resource "exoscale_domain_record" "frontend-dns" {
  provider    = exoscale.dns
  domain      = "89083a5c-b648-474a-0000-0000000ad17d"
  name        = local.project
  record_type = "A"
  ttl         = "60"
  content     = "${data.local_file.ingress-ip.content}"
}
