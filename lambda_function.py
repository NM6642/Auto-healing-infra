import json
import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))
    
    instance_id = "-------" #use your instance id here 
    
    # Restart the instance
    response = ec2.reboot_instances(InstanceIds=[instance_id])
    print(f"Rebooting instance {instance_id}: {response}")
    
    return {
        'statusCode': 200,
        'body': json.dumps(f"Rebooted instance {instance_id}")
    }
