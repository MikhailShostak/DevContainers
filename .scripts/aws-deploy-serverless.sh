#!/bin/bash

set -e
set -o pipefail

app_name=$1

root=$(dirname -- $0)
region=$(aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]')
account=$(aws sts get-caller-identity --query "Account" --output text)

aws ecr get-login-password | docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com
docker build -f $root/node-lambda.dockerfile -t $account.dkr.ecr.$region.amazonaws.com/$app_name .
docker push $account.dkr.ecr.$region.amazonaws.com/$app_name
aws lambda update-function-code --region $region --function-name $app_name --image-uri $account.dkr.ecr.$region.amazonaws.com/$app_name:latest

if [ -d "dist/client" ]
then
	aws s3 sync dist/client s3://$app_name-assets --delete
fi
