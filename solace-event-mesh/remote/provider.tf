terraform {
  required_providers {
    solacebroker = {
      source = "registry.terraform.io/solaceproducts/solacebroker"
    }
  }
}

provider "solacebroker" {
  username       = var.broker_semp_username
  password       = var.broker_semp_password
  url            = var.broker_semp_url
}