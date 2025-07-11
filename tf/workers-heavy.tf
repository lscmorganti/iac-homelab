resource "proxmox_vm_qemu" "workers-heavy" {
  count = local.workers-heavy.count

  target_node = local.proxmox_node
  vmid        = local.workers-heavy.vmid_prefix + count.index
  name = format(
    "%s-%s",
    local.workers-heavy.name_prefix,
    count.index
  )

  onboot = local.onboot
  clone  = local.template
  agent  = local.agent

  cores   = local.workers-heavy.cores
  memory  = local.workers-heavy.memory

  ciuser  = local.cloud_init.user
  sshkeys = local.cloud_init.ssh_public_key
  ipconfig0 = format(
    "ip=%s/24,gw=%s",
    cidrhost(
      local.cidr,
      local.workers-heavy.network_last_octect + count.index
    ),
    cidrhost(local.cidr, 1)
  )

  network {
    id     = 0
    bridge = local.bridge.interface
    model  = local.bridge.model
  }

  scsihw = local.scsihw

  serial {
    id   = local.serial.id
    type = local.serial.type
  }

  disk {
    backup  = local.disks.cloudinit.backup
    format  = local.disks.cloudinit.format
    type    = local.disks.cloudinit.type
    storage = local.disks.cloudinit.storage
    slot    = local.disks.cloudinit.slot
  }

  disk {
    backup  = local.disks.main.backup
    format  = local.disks.main.format
    type    = local.disks.main.type
    storage = local.disks.main.storage
    size    = local.workers-heavy.disk_size
    slot    = local.disks.main.slot
    discard = local.disks.main.discard
  }

  tags = local.workers-heavy.tags

  connection {
    type        = "ssh"
    user        = local.cloud_init.user
    private_key = file("id_rsa")
    host = cidrhost(
      local.cidr,
      local.workers-heavy.network_last_octect + count.index
    )
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }
}