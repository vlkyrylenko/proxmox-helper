#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/vlkyrylenko/proxmox-helper/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: MickLesk (Canbiz)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    __  ___      __  __            __         _     __         
   /  |/  /___ _/ /_/ /____  _____/ /_  _____(_)___/ /___ ____ 
  / /|_/ / __ `/ __/ __/ _ \/ ___/ __ \/ ___/ / __  / __ `/ _ \
 / /  / / /_/ / /_/ /_/  __/ /  / /_/ / /  / / /_/ / /_/ /  __/
/_/  /_/\__,_/\__/\__/\___/_/  /_.___/_/  /_/\__,_/\__, /\___/ 
                                                  /____/                                      
EOF
}
header_info
echo -e "Loading..."
APP="Matterbridge"
var_disk="4"
var_cpu="1"
var_ram="1024"
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
if [[ ! -d /root/Matterbridge ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_error "Update via the Matterbridge UI"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} Setup should be reachable by going to the following URL.
         ${BL}http://${IP}:8283${CL} \n"
