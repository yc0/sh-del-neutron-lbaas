# sh-del-neutron-lbaas
Delete a neutron load balancer
Apparantly, when you try to delete one of lbaas, it is very handy to cope with.
You have to delete lots of works and IDs in order.

Here is the bash. Hopefully, it can save your time.

# prerequisite
I referred to [https://cloudnull.io/2016/10/how-to-delete-a-neutron-load-balancer/]()

However, it is not work for openstack queen.
I made a little change.

```
# first install jq
# sudo apt-get install jq

LB_ID=${your lb id}
LB_DATA=$(neutron lbaas-loadbalancer-show ${LB_ID} --format json)
LB_LISTENERS_ID=$(echo -e "$LB_DATA" | jq .listeners |awk -F'"' '/id/ {print $4}')
LB_POOL_ID=$(echo -e "$LB_DATA" | jq .pools |awk -F'"' '/id/ {print $4}')
LB_HEALTH_ID=$(for i in ${LB_POOL_ID};do neutron lbaas-pool-show -c healthmonitor_id -f value $i;done|awk '/\-/ {print $1}')

for id in $LB_LISTENERS_ID;do neutron lbaas-listener-delete $id;done
for id in $LB_HEALTH_ID;do neutron lbaas-healthmonitor-delete $id;done
for id in $LB_POOL_ID;do neutron lbaas-pool-delete $id;done
neutron lbaas-loadbalancer-delete $LB_ID
```
