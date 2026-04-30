terraform {
  backend "remote" {
    organization = "mel99"
    workspaces {
      name = "infrastructure"
    }

  }
  required_providers {
    portainer = {
      source  = "portainer/portainer"
      version = "1.13.2"
    }
  }
}

provider "portainer" {
  endpoint        = var.endpoint
  api_key         = var.api_key
  skip_ssl_verify = true
}
