# Change version to the currently available Exoscale SKS version
resource "exoscale_sks_cluster" "SKS-Cluster" {
  zone          = local.zone
  name          = "solace-ha"
  version       = "1.32.6"
  description   = "Cluster for Solace HA deployment"
  service_level = "pro"
}

# This provisions an instance pool of nodes which will run the Kubernetes
# workloads. It is possible to attach multiple nodepools to the cluster:
# https://registry.terraform.io/providers/exoscale/exoscale/latest/docs/resources/sks_nodepool
# Check instance types: https://www.exoscale.com/pricing/#/compute/

resource "exoscale_anti_affinity_group" "solace-ha" {
  name        = "solace-ha"
  description = "Prevent compute instances to run on the same host"
}

resource "exoscale_sks_nodepool" "solace-ha" {
  zone               = local.zone
  cluster_id         = exoscale_sks_cluster.SKS-Cluster.id
  name               = "solace-ha"
  instance_type      = "standard.large"
  size               = 3
  security_group_ids = [exoscale_security_group.sks_nodes.id]
  anti_affinity_group_ids = [exoscale_anti_affinity_group.solace-ha.id]
}

# Create a security group so the nodes can communicate and we can pull logs

resource "exoscale_security_group" "sks_nodes" {
  name        = "sks_nodes"
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
