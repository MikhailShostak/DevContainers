#!/bin/bash

set -e

pushd $(dirname -- $0)

docker build . -f .images/.base.dockerfile -t mikhail.shostak/base

docker build . -f .images/aws.dockerfile -t mikhail.shostak/aws
docker build . -f .images/aws-node.dockerfile -t mikhail.shostak/node
docker build . -f .images/aws-python.dockerfile -t mikhail.shostak/python
docker build . -f .images/aws-terraform.dockerfile -t mikhail.shostak/terraform

docker build . -f .images/gui.dockerfile -t mikhail.shostak/gui
docker build . -f .images/gui-perforce.dockerfile -t mikhail.shostak/p4v

docker build . -f .images/perforce.dockerfile -t mikhail.shostak/perforce

docker build . -f .images/aws-conan-debug.dockerfile -t mikhail.shostak/conan-debug
docker build . -f .images/aws-conan-release.dockerfile -t mikhail.shostak/conan-release

docker build . -f .images/aws-godot.dockerfile -t mikhail.shostak/godot
docker build . -f .images/aws-godot-precompiled.dockerfile -t mikhail.shostak/godot-bin

docker image prune -f
docker builder prune -f
