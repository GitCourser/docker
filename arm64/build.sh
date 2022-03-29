#!/bin/bash

sudo apt-get update
sudo apt-get install -y --no-install-recommends qemu-user-static binfmt-support
ls -l /usr/bin/qemu-*
update-binfmts --enable qemu-aarch64
