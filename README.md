### Application Description
This sample application will deploy resources using your default AWS credentials to create a web application that will return the IP address of the client.

### Prerequisites
These scripts assume you have the following installed on your system: Python 3, Boto3 (python package), AWS CLI, AWS credentials with sufficient permissions, and bash.

### How to install
Run the 'install.sh' command to create the necessary resources using CloudFormation.  At the end of the script, the web application will be queried to show your current system's IP address.  The web application's URL will also be displayed at the end of the install process.

### How to see the resources
You can use the AWS web console to see the resources that were created.  https://console.aws.amazon.com/cloudformation.  Find 'myipstack', then click on the resources tab for a list of resources.

### How to access the API
The API's URL will be displayed after running the install.sh command.

### How do I modify this with my own code
The lambda function's code is in myip.py.  You can look at the install.sh script to see how it gets staged on S3.  There is then a reference to the S3 location in the cloudformation.yaml file.  You can modify the existing function's code and re-install.  You can add new functions by writing new code and updating cloudformation.yaml to include more AWS::Lambda::Function resources.  To make new functions accessible from the API, you must add more paths in the API Gateway Body element in the cloudformation.yaml file.

### How to uninstall
Run the 'uninstall.sh' to delete all of the resources that were created in the install step.
