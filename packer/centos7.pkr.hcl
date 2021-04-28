variable "cpus" {
  type    = number
  default = 4
}

variable "disk_size" {
  type    = number
  default = 20000
}

variable "md5sum" {
  type    = string
  default = "a4711c4fa6a1fb32bd555fae8d885b12"
}

variable "memory" {
  type    = string
  default = "1024M"
}

variable "mirror" {
  type    = string
  default = "http://mirror.dst.ca/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso"
}

variable "name" {
  type    = string
  default = "centos-7-x64"
}

variable "username" {
  type    = string
  default = "k8s"
  sensitive = true
}

variable "password" {
  type    = string
  default = "k8s"
  sensitive = true
}

source "qemu" "k8s" {
  accelerator       = "kvm"
  boot_command      = ["<up><wait><tab><wait> inst.text inst.ks=hd:fd0:/kickstart.cfg <enter><wait>"]
  boot_wait         = "2s"
  disk_interface    = "ide"
  disk_size         = "${var.disk_size}"
  floppy_files      = ["kickstart.cfg"]
  format            = "qcow2"
  headless          = true
  iso_checksum      = "md5:${var.md5sum}"
  iso_url           = "${var.mirror}"
  net_device        = "virtio-net"
  output_directory  = "output"
  # qemuargs          = [["-m", "${var.memory}"], ["-smp", "cpus=${var.cpus}"], ["-device", "virtio-net,netdev=forward,id=net0"], ["-netdev", "user,hostfwd=tcp::22-:2200,id=forward"], ["-device", "virtio-net,netdev=net1"], ["-netdev", "user,id=net1,", "net=192.168.76.0/24,dhcpstart=192.168.76.9"]]
  qemuargs          = [["-m", "${var.memory}"], ["-smp", "cpus=${var.cpus}"]]
  shutdown_command  = "echo 'Building finished.' && sleep 5 && sudo poweroff"
  ssh_password      = "${var.password}"
  ssh_port          = 22
  ssh_timeout       = "1200s"
  ssh_username      = "${var.username}"
  vm_name           = "${var.name}.qcow2"
  vnc_port_min      = 6000
  vnc_port_max      = 6000
}

build {
  sources = ["source.qemu.k8s"]
}
