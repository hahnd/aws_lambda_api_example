#!/usr/bin/env python3

import boto3

# get an API Gateway client
client = boto3.client('apigateway')

# read all of the REST APIs
rest_apis = client.get_rest_apis()

# find the REST API named 'myip'
found = None
for rest_api in rest_apis['items']:
    if rest_api['name'] == 'myip':
        found = rest_api
        break

# print the URL
if found:
    print('https://%s.execute-api.%s.amazonaws.com/v1/myip' % (found['id'], boto3.DEFAULT_SESSION.region_name))
else:
    print('Not Found')