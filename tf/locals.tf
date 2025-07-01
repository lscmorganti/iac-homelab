locals {
  # global configurations
  agent        = 1
  cidr         = "192.168.0.0/24"
  onboot       = true
  proxmox_node = "proxmox"
  scsihw       = "virtio-scsi-pci"
  template     = "ubuntu-2204-cloud-init"

  bridge = {
    interface = "vmbr0"
    model     = "virtio"
  }
  disks = {
    main = {
      backup  = true
      format  = "raw"
      type    = "disk"
      storage = "local-lvm"
      slot    = "scsi0"
      discard = true
    }
    cloudinit = {
      backup  = true
      format  = "raw"
      type    = "cloudinit"
      storage = "local-lvm"
      slot    = "ide2"
    }
  }
  # serial is needed to connect via WebGUI console
  serial = {
    id   = 0
    type = "socket"
  }

  # cloud init information to be injected
  cloud_init = {
    user           = "user"
    password       = "user"
    ssh_public_key = var.ssh_public_key
  }

  # master specific configuration
  controlplanes = {
    # how many nodes?
    count = 3

    name_prefix = "k8s-controlplane"
    vmid_prefix = 200

    # hardware info
    cores   = 2
    disk_size = "110G"
    memory    = 2048


    network_last_octect = 20
    tags                = "controlplanes"
  }

  # workers heavy specific configuration
  workers-heavy = {
    count = 3

    name_prefix = "k8s-worker-heavy"
    vmid_prefix = 300

    cores   = 2
    disk_size = "110G"
    memory    = 2048

    network_last_octect = 30
    tags                = "workers-heavy"
  }

  # workers light specific configuration
  workers-light = {
    count = 3

    name_prefix = "k8s-worker-light"
    vmid_prefix = 400

    cores   = 2
    
    disk_size = "110G"
    memory    = 2048

    network_last_octect = 40
    tags                = "workers-light"
  }  
}