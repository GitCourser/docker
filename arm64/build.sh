#!/bin/bash

sudo apt-get update
sudo apt-get install -y --no-install-recommends qemu-user-static binfmt-support
ls /usr/bin/qemu-*
update-binfmts --enable qemu-aarch64
