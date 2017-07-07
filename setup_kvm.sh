#!/bin/bash

set -euo pipefail

source ./common.sh

error_if_root
IMG_STORAGE='/var/lib/libvirt/images'

cd $WORKING_DIR

function whonix_13_steps {
    step "Using 'legacy' Whonix 13 procedure."
    substep "Defining Whonix-Gateway VM."
    virsh -c qemu:///system define Whonix-Gateway*.xml
    substep "Defining Whonix virtual network."
    virsh -c qemu:///system net-define Whonix_network*.xml
    virsh -c qemu:///system net-autostart Whonix
    virsh -c qemu:///system net-start Whonix
    substep "Defining Whonix-Workstation VM."
    virsh -c qemu:///system define Whonix-Workstation*.xml
}

function whonix_14_steps {
    step "Using Whonix 14 procedure."
    subtep  "Defining the Whonix virtual networks."
    virsh -c qemu:///system net-define Whonix_external*.xml
    virsh -c qemu:///system net-define Whonix_internal*.xml
    virsh -c qemu:///system net-autostart external
    virsh -c qemu:///system net-start external
    virsh -c qemu:///system net-autostart internal
    virsh -c qemu:///system net-start internal

    substep "Importing the Whonix VMs."
    virsh -c qemu:///system define Whonix-Gateway*.xml
    virsh -c qemu:///system define Whonix-Workstation*.xml
}

MAJOR_VERSION="$(echo $VERSION | cut -d '.' -f 1)"

if [[ $MAJOR_VERSION == "13" ]]; then
    whonix_13_steps
elif [[ $MAJOR_VERSION == "14"  ]]; then
    whonix_14_steps
else
    error "Don't know what to do with Whonix $MAJOR_VERSION! Sorry."
fi

substep "Moving the image files to $IMG_STORAGE"
substep "Requesting sudo password:"
sudo mv Whonix-Gateway*.qcow2 $IMG_STORAGE/Whonix-Gateway.qcow2
sudo mv Whonix-Workstation*.qcow2 $IMG_STORAGE/Whonix-Workstation.qcow2

step "Done! You can now start Whonix with virt-manager"
