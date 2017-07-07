#!/bin/bash

set -euo pipefail
source ./common.sh

error_if_root # Running this with sudo privileges can't be a good idea.

# See config.sh for the $VERSION variable
BASE="https://download.whonix.org/linux/$VERSION"

GATEWAY_URL="$BASE/Whonix-Gateway-$VERSION.libvirt.xz"
GATEWAY_SIG="$BASE/Whonix-Gateway-$VERSION.libvirt.xz.asc"
GATEWAY_SHA="$BASE/Whonix-Gateway-$VERSION.sha512sums"
GATEWAY_SHA_SIG="$BASE/Whonix-Gateway-$VERSION.sha512sums.asc"

WORKSTATION_URL="$BASE/Whonix-Workstation-$VERSION.libvirt.xz"
WORKSTATION_SIG="$BASE/Whonix-Workstation-$VERSION.libvirt.xz.asc"
WORKSTATION_SHA="$BASE/Whonix-Workstation-$VERSION.sha512sums"
WORKSTATION_SHA_SIG="$BASE/Whonix-Workstation-$VERSION.sha512sums.asc"

SIGNING_KEY_URL='https://www.whonix.org/patrick.asc'
SIGNING_ID='8D66066A2EEACCDA'
SIGNING_EMAIL='Patrick Schleizer <adrelanos@riseup.net>'
SIGNING_FINGERPRINT='Key fingerprint = 916B 8D99 C38E AF5E 8ADC  7A2A 8D66 066A 2EEA CCDA'

THIS_COMMAND="$0"

function get {
    wget -q $1
}

function fail_signing_key_verification {
    error "Unable to verify signing key! This really shouldn't happen."
}

function fail_verification {
    error "Unable to verify $1! This can happen with interrupted or corrupted downloads.\n Try deleting the '$WORKING_DIR' directory and running '$THIS_COMMAND' again."
}

# See config.sh for the $WORKING_DIR variable
mkdir -p $WORKING_DIR
cd $WORKING_DIR

# delete any signatures or checksums that may be lying around
rm *.asc *.sha512sums &>/dev/null || true

step "Downloading the two VM images. This might take a while."
substep "Downloading the Whonix-Gateway VM."
wget --no-clobber $GATEWAY_URL

substep "Downloading the Whonix-Workstation VM."
wget --no-clobber $WORKSTATION_URL

get $GATEWAY_SIG
get $GATEWAY_SHA
get $GATEWAY_SHA_SIG

get $WORKSTATION_SIG
get $WORKSTATION_SHA
get $WORKSTATION_SHA_SIG

step "Verifying the downloads."

substep "Downloading and verifying the signing key."
gpg --fingerprint # just in case this has never been run
chmod --recursive og-rwx ~/.gnupg
get $SIGNING_KEY_URL -O patrick.asc
gpg --keyid-format long --with-fingerprint patrick.asc | grep "$SIGNING_ID" || \
    fail_signing_key_verification
gpg --keyid-format long --with-fingerprint patrick.asc | grep "$SIGNING_EMAIL" || \
    fail_signing_key_verification
gpg --keyid-format long --with-fingerprint patrick.asc | grep "$SIGNING_FINGERPRINT" || \
    fail_signing_key_verification

substep "Signing key verified. Importing."
gpg --import patrick.asc

substep "Verifying Whonix-Gateway."
gpg --verify-options show-notations --verify Whonix-Gateway-*.libvirt.xz.asc Whonix-Gateway-*.libvirt.xz || \
    fail_verification "Whonix-Gateway"

substep "Verifying Whonix-Workstation."
gpg --verify-options show-notations --verify Whonix-Workstation-*.libvirt.xz.asc Whonix-Workstation-*.libvirt.xz || \
    fail_verification "Whonix-Workstation"

substep "Files verified successfully."

step "Decompressing verified VMs."
tar -xf Whonix-Gateway*.libvirt.xz
tar -xf Whonix-Workstation*.libvirt.xz

step "Done!"
step "The next step is 'setup_kvm.sh'."
