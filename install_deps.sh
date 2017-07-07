#!/bin/bash

set -euo pipefail
source ./common.sh

step "Installing required dependencies."
substep "Requesting sudo password to install packages."
sudo apt-get update
sudo apt-get install -y qemu-kvm libvirt-bin virt-manager libvirt-daemon-system libvirt-clients

step "Done! You may also want to install and enable apparmor if you haven't already."
step "The next step is 'user_setup.sh'."
