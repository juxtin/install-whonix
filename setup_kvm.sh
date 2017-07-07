#!/bin/bash

set -euo pipefail

source ./common.sh

error_if_root
IMG_STORAGE='/var/lib/libvirt/images'

cd $WORKING_DIR

step "Defining the Whonix virtual networks."
virsh -c qemu:///system net-define Whonix_external*.xml
virsh -c qemu:///system net-define Whonix_internal*.xml
virsh -c qemu:///system net-autostart external
virsh -c qemu:///system net-start external
virsh -c qemu:///system net-autostart internal
virsh -c qemu:///system net-start internal

step "Importing the Whonix VMs."
virsh -c qemu:///system define Whonix-Gateway*.xml
virsh -c qemu:///system define Whonix-Workstation*.xml

step "Moving the image files to $IMG_STORAGE"
substep "Requesting sudo password:"
sudo mv Whonix-Gateway*.qcow2 $IMG_STORAGE/Whonix-Gateway.qcow2
sudo mv Whonix-Workstation*.qcow2 $IMG_STORAGE/Whonix-Workstation.qcow2

step "Done! You can now start Whonix with virt-manager"
