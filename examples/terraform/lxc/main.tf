terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://pve0node0.sikademo.com:8006/api2/json"
  pm_tls_insecure = true
  pm_user         = "root@pam"
  pm_password     = "asdfasdf2020"
  pm_otp          = ""
}


resource "proxmox_lxc" "example" {
  count = 3

  vmid            = 200 + count.index
  start           = true
  target_node     = "pve0node0"
  hostname        = "lxc-${count.index}"
  ostemplate      = "nfs:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
  password        = "asdfasdf"
  ssh_public_keys = <<-EOT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslNKgLyoOrGDerz9pA4a4Mc+EquVzX52AkJZz+ecFCYZ4XQjcg2BK1P9xYfWzzl33fHow6pV/C6QC3Fgjw7txUeH7iQ5FjRVIlxiltfYJH4RvvtXcjqjk8uVDhEcw7bINVKVIS856Qn9jPwnHIhJtRJe9emE7YsJRmNSOtggYk/MaV2Ayx+9mcYnA/9SBy45FPHjMlxntoOkKqBThWE7Tjym44UNf44G8fd+kmNYzGw9T5IKpH1E1wMR+32QJBobX6d7k39jJe8lgHdsUYMbeJOFPKgbWlnx9VbkZh+seMSjhroTgniHjUl8wBFgw0YnhJ/90MgJJL4BToxu9PVnH ondrejsika
  EOT
  unprivileged    = true

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "ceph"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr1"
    ip     = "10.255.0.${200 + count.index}/24"
    gw     = "10.255.0.1"
  }
}
