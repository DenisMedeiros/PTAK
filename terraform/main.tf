
variable "disk_size" {
  type        = number
  description = "Default disk size"
}

variable "pool" {
  type          = string
  description   = "Libvirt pool where the volumes will be created"
}

variable "packer_image" {
  type          = string
  description   = "A QEMU valid image."
}

terraform {
  required_version = ">= 0.13"
  backend "local" {
    path = "./terraform.tfstate"
  }
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

provider "libvirt" {
  uri   = "qemu:///system"
}

module "dev" {
  source = "./dev"
  # Variables (they must exist in the module as well).
  disk_size = var.disk_size
  pool = var.pool
  packer_image = var.packer_image
}
