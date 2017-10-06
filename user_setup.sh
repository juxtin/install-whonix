#!/bin/bash

set -euo pipefail
source ./common.sh

error_if_root

step "Requesting sudo to add $(whoami) to groups 'libvirt' and 'kvm'."
sudo addgroup "$(whoami)" libvirt
sudo addgroup "$(whoami)" kvm

step "Done! Please reboot before continuing."
step "The next step (after reboot) will be 'download_and_verify.sh'."
