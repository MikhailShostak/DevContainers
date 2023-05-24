#!/bin/bash

set -e

docker build . -f .images/.base.dockerfile -t mikhail.shostak/base

docker build . -f .images/aws.dockerfile -t mikhail.shostak/aws
docker build . -f .images/aws-node.dockerfile -t mikhail.shostak/node
docker build . -f .images/aws-python.dockerfile -t mikhail.shostak/python
docker build . -f .images/aws-terraform.dockerfile -t mikhail.shostak/terraform

docker build . -f .images/gui.dockerfile -t mikhail.shostak/gui

docker build . -f .images/aws-conan.dockerfile -t mikhail.shostak/conan

docker image prune -f
docker builder prune -f
