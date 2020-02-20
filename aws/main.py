import boto3
client = boto3.client('lightsail')
print(client.get_active_names())