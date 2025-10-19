
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9.14"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}