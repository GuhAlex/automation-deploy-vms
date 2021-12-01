data "vsphere_datacenter" "dc" {
    name = var.vsphere-datacenter
}

data "vsphere_datastore" "datastore" {
    name = var.vm-datastore
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
    name = var.vsphere-cluster
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
    name = var.vm-network
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
    name = var.vm-template
    datacenter_id = data.vsphere_datacenter.dc.id
}


#resource "vsphere_folder" "folder" {
#  path          = var.vm-folder
#  type          = "vm"
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

resource "vsphere_virtual_machine" "vm" {
    name             = var.vm-name
    resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id     = data.vsphere_datastore.datastore.id
    folder           = var.vm-folder

    num_cpus = var.vm-cpu
    memory   = var.vm-ram
    guest_id = data.vsphere_virtual_machine.template.guest_id

    network_interface {
        network_id = data.vsphere_network.network.id
    }

    disk {
        label = "${var.vm-name}-disk"
        size  = var.vm-disk-size
    }

    clone {
        template_uuid = data.vsphere_virtual_machine.template.id
        customize {
            timeout = 0

            linux_options {
            host_name = var.vm-hostname
            domain = var.vm-domain
            }

            network_interface {
            ipv4_address = var.vm-ipv4-address
            ipv4_netmask = var.vm-ipv4-netmask
            }

            ipv4_gateway = var.vm-ipv4-gateway
            dns_server_list = [ var.vm-dns ]
        }
    }
}
