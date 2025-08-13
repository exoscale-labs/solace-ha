resource "solacebroker_msg_vpn" "solacebroker_msg_vpn" {
  dmr_enabled                              = true
  enabled                                  = true
  max_msg_spool_usage                      = 50000
  msg_vpn_name                             = var.broker_msg_vpn_name
}

resource "solacebroker_dmr_cluster" "solacebroker_dmr_cluster" {
  authentication_basic_enabled             = true
  authentication_basic_password            = var.broker_cluster_password
  dmr_cluster_name                         = var.broker_cluster_name
  enabled                                  = true
}

resource "solacebroker_dmr_cluster_link" "solacebroker_dmr_cluster_link" {
  depends_on = [solacebroker_dmr_cluster.solacebroker_dmr_cluster]
  remote_node_name                         = var.broker_remote_node_name
  authentication_basic_password            = var.broker_cluster_password
  dmr_cluster_name                         = var.broker_cluster_name
  enabled                                  = false
  initiator                                = "local"
  span                                     = "external"
}

resource "solacebroker_dmr_cluster_link_remote_address" "solacebroker_dmr_cluster_link_remote_address" {
  depends_on = [solacebroker_dmr_cluster_link.solacebroker_dmr_cluster_link]
  remote_node_name                         = var.broker_remote_node_name
  remote_address                           = var.broker_remote_address
  dmr_cluster_name                         = var.broker_cluster_name
}

resource "solacebroker_dmr_cluster_link" "solacebroker_dmr_cluster_link_enabled" {
  depends_on = [solacebroker_dmr_cluster_link_remote_address.solacebroker_dmr_cluster_link_remote_address]
  remote_node_name                         = var.broker_remote_node_name
  dmr_cluster_name                         = var.broker_cluster_name  
  enabled                                  = true
}

resource "solacebroker_msg_vpn_dmr_bridge" "solacebroker_msg_vpn_dmr_bridge" {
  depends_on = [solacebroker_dmr_cluster.solacebroker_dmr_cluster]
  remote_node_name                         = var.broker_remote_node_name
  msg_vpn_name                             = var.broker_msg_vpn_name
  remote_msg_vpn_name                      = var.broker_remote_msg_vpn_name
}