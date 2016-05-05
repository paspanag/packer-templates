packer-templates
================

Packer templates used to build base box images at the OSL

Before using, I recommend you set the following in your `.bashrc` or
`.bash_profile`. It will ensure all of the ISO's downloaded reside in a single
location instead of saving them in each folder.

    export PACKER_CACHE_DIR="/home/lance/packer_cache"

This is a fork of packer-templates. Removed all other vagrant images except for centos5-x86_64. This changes the default virtual box to kvm.
