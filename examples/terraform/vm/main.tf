locals {
  vms = {
    "120" = {
      name   = "tf120"
      cores  = 2
      memory = 2048
    }
    "121" = {
      name   = "tf121"
      cores  = 1
      memory = 512
    }
  }
}


resource "proxmox_pool" "tf" {
  poolid = "tf"
}

module "vms" {
  source = "./modules/vm"

  for_each = local.vms

  clone       = "T-debian13"
  vmid        = each.key
  name        = each.value.name
  target_node = "pve0node0"
  pool        = proxmox_pool.tf.poolid

  cores  = each.value.cores
  memory = each.value.memory

  storage   = "ceph"
  disk_size = "11G"

  ip = "10.10.10.${each.key}/24"
  gw = "10.10.10.1"

  username = "root"
  password = "asdfasdf2020"
}
