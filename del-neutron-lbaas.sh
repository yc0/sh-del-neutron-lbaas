#!/bin/bash

read -p "Enter lbaas id you want to remove : " LB_ID
#LB_ID=${your lb id}
LB_DATA=$(neutron lbaas-loadbalancer-show ${LB_ID} --format json)
LB_LISTENERS_ID=$(echo -e "$LB_DATA" | jq .listeners |awk -F'"' '/id/ {print $4}')
LB_POOL_ID=$(echo -e "$LB_DATA" | jq .pools |awk -F'"' '/id/ {print $4}')
LB_HEALTH_ID=$(for i in ${LB_POOL_ID};do neutron lbaas-pool-show -c healthmonitor_id -f value $i;done|awk '/\-/ {print $1}')

for id in $LB_LISTENERS_ID;do neutron lbaas-listener-delete $id;done
for id in $LB_HEALTH_ID;do neutron lbaas-healthmonitor-delete $id;done
for id in $LB_POOL_ID;do neutron lbaas-pool-delete $id;done
neutron lbaas-loadbalancer-delete $LB_ID
