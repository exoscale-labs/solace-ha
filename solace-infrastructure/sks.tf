# Change version to the currently available Exoscale SKS version
resource "exoscale_sks_cluster" "solace-ha" {
  zone          = local.zone
  name          = local.project
  version       = "1.32.6"
  description   = "Cluster for Solace HA deployment ${local.project}"
  service_level = "pro"
  exoscale_ccm  = true
  exoscale_csi  = true
}

# This provisions an instance pool of nodes which will run the Kubernetes
# workloads. It is possible to attach multiple nodepools to the cluster:
# https://registry.terraform.io/providers/exoscale/exoscale/latest/docs/resources/sks_nodepool
# Check instance types: https://www.exoscale.com/pricing/#/compute/

resource "exoscale_anti_affinity_group" "solace-ha" {
  name        = "solace-${local.project}"
  description = "Prevent compute instances to run on the same host"
}

resource "exoscale_sks_nodepool" "solace-ha" {
  zone               = local.zone
  cluster_id         = exoscale_sks_cluster.solace-ha.id
  name               = local.project
  instance_prefix    = local.project
  instance_type      = "standard.large"
  size               = 3
  security_group_ids = [exoscale_security_group.sks_nodes.id]
  anti_affinity_group_ids = [exoscale_anti_affinity_group.solace-ha.id]
}

# Create a security group so the nodes can communicate and we can pull logs

resource "exoscale_security_group" "sks_nodes" {
  name        = "sg-${local.project}"
  description = "Allows traffic between sks nodes and public pulling of logs"
}

resource "exoscale_security_group_rule" "sks_nodes_logs_rule" {
  security_group_id = exoscale_security_group.sks_nodes.id
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 10250
  end_port          = 10250
  description       = "Kubelet"
  user_security_group_id = exoscale_security_group.sks_nodes.id
}

resource "exoscale_security_group_rule" "sks_nodes_calico" {
  security_group_id      = exoscale_security_group.sks_nodes.id
  type                   = "INGRESS"
  protocol               = "UDP"
  start_port             = 4789
  end_port               = 4789
  description            = "Calico CNI networking"
  user_security_group_id = exoscale_security_group.sks_nodes.id
}

resource "exoscale_security_group_rule" "sks_nodes_ccm" {
  security_group_id = exoscale_security_group.sks_nodes.id
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 30000
  end_port          = 32767
  description       = "NodePort services"
  cidr              = "0.0.0.0/0"
}

resource "exoscale_sks_kubeconfig" "solace-ha_admin" {
  ttl_seconds = 360000
  early_renewal_seconds = 300
  cluster_id = exoscale_sks_cluster.solace-ha.id
  zone = exoscale_sks_cluster.solace-ha.zone
  user = "solace-ha-admin"
  groups = ["system:masters"]
}

resource "local_file" "kube_config" {
  content = exoscale_sks_kubeconfig.solace-ha_admin.kubeconfig
  filename = "kube_config"
}
