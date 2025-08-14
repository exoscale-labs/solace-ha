terraform {
  required_version = ">= 0.13"
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
    }
  }
}

provider "exoscale" {
  key = "${var.exoscale_api_key}"
  secret = "${var.exoscale_secret_key}"
}
