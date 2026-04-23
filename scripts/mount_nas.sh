#!/usr/bin/env bash

read -rp "NAS IP [192.168.1.100]: " ip
ip=${ip:-192.168.1.100}

password=$(pass smb/nas/spiperac)

mkdir -p ~/NAS/{backup,multimedia}

sudo mount_smbfs -I "$ip" \
  "//spiperac:${password}@${ip}/homes/spiperac" ~/NAS/backup

sudo mount_smbfs -I "$ip" \
  "//spiperac:${password}@${ip}/video" ~/NAS/multimedia
