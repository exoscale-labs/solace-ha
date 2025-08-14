resource "null_resource" "solace-operator" {
  provisioner "local-exec" {
    command      = "kubectl --kubeconfig kube_config apply -f solace-k8s/deploy.yaml"
  }
  depends_on = [
    resource.local_file.kube_config
  ]
}

resource "null_resource" "solace-deploy-validation" {
  provisioner "local-exec" {
    command      = "kubectl --kubeconfig kube_config rollout status deployment pubsubplus-eventbroker-operator -n pubsubplus-operator-system --timeout=240s"
  }
  depends_on = [
    resource.null_resource.solace-operator
  ]
}

resource "null_resource" "ha-exoscale" {
  provisioner "local-exec" {
    command      = "kubectl --kubeconfig kube_config apply -f solace-k8s/ha-exoscale.yaml"
  }
  depends_on = [
    resource.null_resource.solace-deploy-validation
  ]
}
