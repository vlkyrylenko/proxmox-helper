#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/vlkyrylenko/proxmox-helper/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    __ __                __            __  
   / //_/__  __  _______/ /___  ____ _/ /__
  / ,< / _ \/ / / / ___/ / __ \/ __  / //_/
 / /| /  __/ /_/ / /__/ / /_/ / /_/ / ,<   
/_/ |_\___/\__, /\___/_/\____/\__,_/_/|_|  
          /____/                           

EOF
}
header_info
echo -e "Loading..."
APP="Keycloak"
var_disk="4"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -f /etc/systemd/system/keycloak.service ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating ${APP} LXC"

msg_info "Updating packages"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null

RELEASE=$(curl -s https://api.github.com/repos/keycloak/keycloak/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
msg_info "Downloading Keycloak v$RELEASE"
cd /opt
wget -q https://github.com/keycloak/keycloak/releases/download/$RELEASE/keycloak-$RELEASE.tar.gz
$STD tar -xvf keycloak-$RELEASE.tar.gz

msg_info "Merging configuration files"
cp -r keycloak/conf keycloak-$RELEASE
cp -r keycloak/providers keycloak-$RELEASE
cp -r keycloak/themes keycloak-$RELEASE

msg_info "Updating Keycloak"
mv keycloak keycloak.old
mv keycloak-$RELEASE keycloak

msg_info "Delete temporary installation files"
rm keycloak-$RELEASE.tar.gz
rm -rf keycloak.old

msg_info "Restating Keycloak"
systemctl restart keycloak
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:8080/admin${CL} \n"
