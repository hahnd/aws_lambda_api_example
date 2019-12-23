#!/usr/bin/env bash

bucket_name="${USER}myipexample$(date +%s)"
echo -n ${bucket_name} > .bucket_name

# make sure we have an S3 bucket to hold our lambda code
aws s3 ls s3://${bucket_name} > /dev/null 2>&1
if [[ $? == 255 ]]; then
    # bucket does not exist, create it
    aws s3 mb s3://${bucket_name}/
    if [[ $? != 0 ]]; then
      echo "Failed to create S3 bucket: ${bucket_name}"
      exit 1
    fi
fi

# zip the lambda code and copy to S3 - make sure all code and directories have at least 555 permissions (read/execute)
chmod ugo+rx myip.py
zip lambda_code.zip myip.py
aws s3 cp lambda_code.zip s3://${bucket_name}/lambda_code.zip

# create the cloudformation stack
aws cloudformation create-stack \
    --stack-name myipstack \
    --template-body file://./cloudformation.yaml \
    --parameters ParameterKey=BucketName,ParameterValue=${bucket_name} \
    --capabilities CAPABILITY_NAMED_IAM

# print a URL to check status if process was ok
if [[ $? == 0 ]]; then
  echo "Check CloudFormation Stack status at https://console.aws.amazon.com/cloudformation/"
fi

# monitor the cloudformation stack status
status="unknown"
while [[ $status != "CREATE_COMPLETE" && $status != "ROLLBACK_COMPLETE" ]]; do
  status=$(aws cloudformation describe-stacks --stack-name myipstack | grep StackStatus | awk -F ":" \{print\$2\} | grep -o '".*"' | sed s/\"//g)
  echo $(date) $status
  sleep 2
done

# exit the script if the stack creation failed
if [[ $status == "ROLLBACK_COMPLETE" ]]; then
  return
fi

# get the new API's URL
url=$(python3 get_url.py)
echo "My IP is: $(curl -s ${url})"
echo "The REST API's URL is: ${url}"
