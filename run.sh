#!/bin/bash

set -e

docker compose -f $1 up -d $2
docker compose -f $1 exec $2 /bin/bash
