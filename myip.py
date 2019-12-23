def lambda_main(event, context):
    """
    Return a response with the client's IP address
    """
    print(event)
    response = {
        'isBase64Encoded': False,
        'statusCode': 200,
        'body': event['requestContext']['identity']['sourceIp']
    }

    return response
