# Using an existing Packer image as template.

resource "libvirt_volume" "k8s1_disk1" {
  name   = "k8s1-disk1"
  pool   = var.pool
  source = var.packer_image
}

resource "libvirt_volume" "k8s2_disk1" {
  name   = "k8s2-disk1"
  pool   = var.pool
  source = var.packer_image
}

resource "libvirt_volume" "k8s3_disk1" {
  name           = "k8s3-disk1"
  pool   = var.pool
  source = var.packer_image
}


# Creating extra disks for instances.

resource "libvirt_volume" "k8s1_disk2" {
  name   = "k8s1-disk2"
  format = "qcow2"
  pool   = var.pool
  size   = var.disk_size
}

resource "libvirt_volume" "k8s2_disk2" {
  name   = "k8s2-disk2"
  format = "qcow2"
  pool   = var.pool
  size   = var.disk_size
}

resource "libvirt_volume" "k8s3_disk2" {
  name   = "k8s3-disk2"
  format = "qcow2"
  pool   = var.pool
  size   = var.disk_size
}

# Domains / virtual machines.

resource "libvirt_domain" "k8s1" {
  name = "k8s1"
  vcpu = 2
  memory = 2048
  running = true

  # Disk based on the QEMU image (operating system).
  disk {
    volume_id = libvirt_volume.k8s1_disk1.id
    scsi = true
  }

  # Extra disk (more space.)
  disk {
    volume_id = libvirt_volume.k8s1_disk2.id
    scsi = true
  }

  network_interface {
    network_id     = libvirt_network.k8s.id
    hostname       = "k8s1"
    addresses      = ["10.77.0.10"]
  }
}

resource "libvirt_domain" "k8s2" {
  name = "k8s2"
  vcpu = 2
  memory = 2048
  running = true

  # Disk based on the QEMU image (operating system).
  disk {
    volume_id = libvirt_volume.k8s2_disk1.id
    scsi = true
  }

  # Extra disk (more space.)
  disk {
    volume_id = libvirt_volume.k8s2_disk2.id
    scsi = true
  }

  network_interface {
    network_id     = libvirt_network.k8s.id
    hostname       = "k8s2"
    addresses      = ["10.77.0.20"]
  }
}

resource "libvirt_domain" "k8s3" {
  name = "k8s3"
  vcpu = 2
  memory = 2048
  running = true

  # Disk based on the QEMU image (operating system).
  disk {
    volume_id = libvirt_volume.k8s3_disk1.id
    scsi = true
  }

  # Extra disk (more space.)

  disk {
    volume_id = libvirt_volume.k8s3_disk2.id
    scsi = true
  }

  network_interface {
    network_id     = libvirt_network.k8s.id
    hostname       = "k8s3"
    addresses      = ["10.77.0.30"]
  }
}