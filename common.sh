#!/bin/bash

source config.sh

GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function step {
    printf "${LIGHT_GREEN}  $*  ${NC}\n"
}

function substep {
    printf "${GREEN}      $*  ${NC}\n"
}

function error {
    printf "${RED} $* ${NC}\n"
    exit 1
}

function error_if_root {
    if [[ "$(whoami)" = "root" ]]; then
        error "Don't run this as root! Run it normally and let it prompt you for sudo access if necessary."
    fi
}
