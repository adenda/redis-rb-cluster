#!/bin/bash

echo "Waiting 5 seconds"

sleep 5

echo "Starting Redis Cluster test with start host $REDIS_RB_CLUSTER_HOST at port $REDIS_RB_CLUSTER_PORT"

ruby ./example.rb "$REDIS_RB_CLUSTER_HOST" "$REDIS_RB_CLUSTER_PORT" tee /dev/stdout