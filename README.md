# Whonix KVM installer

This is a series of scripts that I used to semi-automate the process of following [this document](https://www.whonix.org/wiki/KVM#KVM_Setup_Instructions) to set up Whonix with KVM on Ubuntu 17.04. From start to finish, it does the following:

1. Install KVM and dependencies
2. Make sure the current user is able to run KVM images without sudo
3. Download and verify the gateway and workstation images
4. Import the image files into KVM so that Whonix is ready to run

## requirements

This is only tested on Ubuntu 17.04.
It will probably work fine on other Debian-like systems, and if you're willing to make some changes in `./install_deps.sh` then it should be pretty easy to get it to run on other distros as well.

## how to use it

All you have to do is run the scripts in this order:

1. `./install_deps.sh`
2. `./user_setup.sh`
3. (restart)
4. `./download_and_verify.sh`
5. `./setup_kvm.sh`

## using other download sources

By default, the `download_and_verify.sh` script uses the official Whonix https source.
If you prefer to download the images from another source, just place the `.xz` files (and those files only) in the working directory (`./build` by default), make sure the version number matches what it says in `config.sh`, and run `download_and_verify.sh`.
It will skip the image download, but still get the signing key and signature files over https and verify the images you downloaded.

## optional configuration

There are two user-configurable settings, managed in `config.sh`:

1. `VERSION`: see https://download.whonix.org/linux/ for possible values.
2. `WORKING_DIR`: use whatever you want, but **these scripts will delete things in that directory**, so it's better to leave it as is.

## warranty

Seriously, there is none. I've written this pretty carefully, but there's really no limit to the damage it could cause your system. Run it at your own risk.

## license

This code is made available under the GNU General Public License v3. See the LICENSE file for more details.
