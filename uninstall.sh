#!/usr/bin/env bash

# delete the cloudformation stack
aws cloudformation delete-stack --stack-name myipstack

# print a URL to check status if process was ok
if [[ $? == 0 ]]; then
  echo "Check CloudFormation Stack status at https://console.aws.amazon.com/cloudformation/"
fi

# remove the lambda code from S3 and delete the bucket
bucket_name=$(cat .bucket_name)
if [[ ${bucket_name} != "" ]]; then
    aws s3 rm s3://${bucket_name}/lambda_code.zip
    aws s3 rb s3://${bucket_name}
    rm .bucket_name
fi

# monitor the status of the cloudformation stack
status="unknown"
while [[ $status != "DELETE_COMPLETE" ]]; do
  status=$(aws cloudformation describe-stacks --stack-name myipstack | grep StackStatus | awk -F ":" \{print\$2\} | grep -o '".*"' | sed s/\"//g)
  if [[ $status == "" ]]; then
    status="DELETE_COMPLETE"
  fi
  echo $(date) ${status}
  sleep 2
done

