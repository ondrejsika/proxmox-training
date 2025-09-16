terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

variable "pm_api_url" {}
variable "pm_user" {}
variable "pm_password" {}

provider "proxmox" {
  pm_api_url  = var.pm_api_url
  pm_user     = var.pm_user
  pm_password = var.pm_password
  pm_otp      = ""
}

