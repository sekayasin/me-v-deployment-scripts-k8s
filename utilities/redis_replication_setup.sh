#!/bin/bash

:'
This utility script is intended to automate the setup of the Redis Replication set.
Once the StatefulSet app is deployed on the kubernetes cluster of choice, this script
should be run to set up the replica chain.

It uses the kubectl commandline tool to retrieve the IPs of all the redis server pods,
then creates an array of said IPs and executes the REPLICAOF command in respective
to create a "daisy chain" replica set; where the next server in the series is a slave/replica
of its predecessor.

# How to use
The usage of the script is quite simple but has the following prerequistes
    1. Ensure you have the kubectl commandline tool installed and accessible through bash
    2. Ensure the current cluster context is the one the apprenticeship-redis StatefulSet 
       app is deployed to.

To execute, cd into the the utilities directory and run either of the following commands

  $ ./redis_replication_setup.sh main

  $ ../redis_replication_setup.sh assign_replicas
'

assign_replicas() {
    # Get the server IPs
    redisServerIPs=$(kubectl get pods -o jsonpath='{range.items[*]}{.status.podIP};' | tr ";" "\n")
    # initialize array index
    i=0
    # loop through the set of IPs creating an array 
    for server in ${redisServerIPs}
    do
        servers[$i]=$server
        ((i++))
    done

    # Loop through the array setting the next server as a replica of the 
    # current server
    for ((j=0;j<${#servers[@]};j++))
    do
        ((k=j+1))
        if [ "$k" != "${#servers[@]}" ]; then
            kubectl exec -it apprenticeship-redis-$k -- redis-cli REPLICAOF ${servers[j]} 6379
        fi
    done
}

main() {
    assign_replicas
}

"$@"
