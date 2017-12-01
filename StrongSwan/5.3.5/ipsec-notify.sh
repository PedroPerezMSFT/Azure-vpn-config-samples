#!/bin/bash
# Credit to Endre Szabó https://end.re/2015-01-06_vti-tunnel-interface-with-strongswan.html
# [UPDATE] 2017-12-01 :: Made the values static
# Replace: 
# LOCALPEERIP with your StrongSwan's public IP
# AZUREPEERIP with the Azure VPN Gateway's public IP
# x.x.x.x/x with your Azure VNet's address space

set -o nounset
set -o errexit

VTI_IF="vti0"

case "${PLUTO_VERB}" in
    up-client)
        ip tunnel add "vti0" local LOCALPEERIP remote AZUREPEERIP mode vti \
            key 2
        ip link set "vti0" up
        ip route add x.x.x.x/x dev "vti0"        
        sysctl -w "net.ipv4.conf.vti0.disable_policy=1"
        ;;
    down-client)
        ip tunnel del "vti0"
        ;;
esac