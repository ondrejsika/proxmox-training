terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

variable "clone" {
  description = "The name of the template to clone"
  type        = string
}

variable "vmid" {
  description = "The ID of the virtual machine"
  type        = number
}

variable "name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "target_node" {
  description = "The Proxmox node where the VM will be created"
  type        = string
}

variable "cores" {
  description = "The number of CPU cores for the VM"
  type        = number
}

variable "memory" {
  description = "The amount of memory (in MB) for the VM"
  type        = number
}

variable "ip" {
  description = "The last octet of the VM's IP address"
  type        = string
}

variable "gw" {
  description = "The gateway for the VM"
  type        = string
}

variable "username" {
  description = "The username for the VM"
  type        = string
}

variable "password" {
  description = "The password for the VM"
  type        = string
}

variable "storage" {
  description = "The storage where the VM's disk will be created"
  type        = string
}

variable "disk_size" {
  description = "The size of the VM's disk"
  type        = string
}

variable "pool" {
  description = "The Proxmox pool to which the VM will be added"
  type        = string
  default     = ""
}

resource "proxmox_vm_qemu" "this" {
  lifecycle {
    ignore_changes = [tags]
  }

  vmid        = var.vmid
  name        = var.name
  target_node = var.target_node
  pool        = var.pool
  agent       = 1
  cpu {
    cores = var.cores
  }
  memory           = var.memory
  boot             = "order=scsi0" # has to be the same as the OS disk of the template
  clone            = var.clone
  scsihw           = "virtio-scsi-single"
  vm_state         = "running"
  automatic_reboot = false

  # Cloud-Init configuration
  ciupgrade  = false
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=${var.ip},gw=${var.gw}"
  skip_ipv6  = true
  ciuser     = var.username
  cipassword = var.password

  disks {
    scsi {
      scsi0 {
        # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
        disk {
          storage = var.storage
          # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
          size = var.disk_size
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide1 {
        cloudinit {
          storage = var.storage
        }
      }
    }
  }

  network {
    id     = 0
    bridge = "vmbr1"
    model  = "virtio"
  }
}
