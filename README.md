# PTAK  - K8S cluster built with Ansible, Terraform, and Packer

This project can be used to create a local Kubernetes using several DevOps tools.
It's a cheap and easy way to play with these tools locally.

The tools used in this project are described below.

- **Packer**: image building tool to create qemu images. 
- **KVM/ Libvirt**: hypervisor used to build the virtual machines.
- **Terraform**: infrastructure as code (IaC) tool to create the virtual machines.
- **Ansible**: configuration management tool to configure the virtual machines and deploy and configure Kubernetes.
- **Kubernetes (K8S)** - used for container orchestration.

### Requirements

This project was primarily tested on Linux (Ubuntu 18.04 LTS) but can be used on other similar platforms as well.

1. Install KVM and libvirt on your machine.

```bash
# Main packages.
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Optinal packages.
sudo apt install -y virt-manager
```

2. Install Terraform:

```bash
# Follow the official guide.
https://learn.hashicorp.com/tutorials/terraform/install-cli
```

3. Install Packer.

```bash
# Follow the official guide.
https://www.packer.io/downloads
```

4. Install the Terraform-libvirt plugin

```bash
# Follow the official guide.
https://github.com/dmacvicar/terraform-provider-libvirt

# If you are using a newer Terraform version:
https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/docs/migration-13.md
```

## Packer Usage

In this stage, we will use Packer to create a CentOS 7 QEMU image to be used by Libvirt later on.

1. Edit the files `vars.hcl` and `kickstart.cfg` accordingly.

2. Run packer to build the image. If your user does not have permissions to run
qemu by default, you may need to run it with `sudo`.

```bash
# Run packer to build image.
sudo PACKER_LOG=1 packer build centos7.pkr.hcl
```

If you want to see the image being built in real time, you can connect to it via 
VNC. For example:

```bash
# Open a VNC session to the VM white it's being built.
xtightvncviewer 127.0.0.1:6000
```

When the image is done, you may need to change its ownership.

```bash
sudo chown -R $(whoami): output/
```

For extra documentation on the Kickstart file:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax

## Libvirt Usage

You don't need to change anything in the default configuration of libvirt. If you want,
you can create a pool (dir, LVM - volume group, etc) in advance to store the virtual machines
disks.

Important note: if you are using Ubuntu, you may encounter some issues with libvirt
permissions (related to how apparmmor handles the libvirt permissions).
To fix this, add the config `security = "none"` to the file `/etc/libvirt/qemu.conf`
and then restart the libvirtd daemon as follows:

```bash
sudo systemctl restart libvirt-bin
```

More info on this issue: https://github.com/dmacvicar/terraform-provider-libvirt/issues/97

## Terraform Usage

Once you have finished building a QEMU image, you can use it as a template for the
nodes that we will build using Terraform.

1. Change the variables on the `variables.tfvars` as needed.

2. Change any definition in the module `dev` (or create more modules).

3. Run Terraform to create the nodes.

```bash
# Verify the proposed changes.
terraform plan

# Apply the changes if they were proposed as expected.
terraform apply
```

At this point, you can even open virt-manager to confirm the new VMs are up and
running.

## Ansible Usage

TODO (WIP)