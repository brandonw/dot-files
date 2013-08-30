#!/bin/sh

virt-install --connect=qemu:///system -n precise64 -r 512 --vcpus 1 -c /var/lib/libvirt/images/ubuntu-12.04.2-server-amd64.iso --os-type=linux --os-variant=ubuntuprecise --disk /var/lib/libvirt/images/precise64.img,size=5,format=qcow2
