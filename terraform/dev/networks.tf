resource "libvirt_network" "k8s" {
  name = "k8snet"
  mode = "nat"
  domain = "k8s.local"
  addresses = ["10.77.0.0/24"]
  mtu = 1500
  autostart = true

  dns {
    enabled = true
    local_only = true

    # Hosts entries.
    hosts  {
      hostname = "k8s1"
      ip = "10.77.0.10"
    }
    hosts {
      hostname = "k8s2"
      ip = "10.77.0.20"
    }

    hosts {
      hostname = "k8s3"
      ip = "10.77.0.30"
    }
  }

}
