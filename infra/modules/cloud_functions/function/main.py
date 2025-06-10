import os
import io
import uuid
import imghdr
from PIL import Image
import boto3

s3 = boto3.client(
    's3',
    endpoint_url='https://storage.yandexcloud.net',
    aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY']
)


def handler(event, context):
    try:
        if event['httpMethod'] == 'GET':
            return handle_get(event)
        elif event['httpMethod'] == 'POST':
            return handle_post(event)
        return error_response(405, "Method not allowed")
    except Exception as e:
        return error_response(500, f"Internal error: {str(e)}")


def handle_get(event):
    params = event.get('queryStringParameters', {})
    if 'id' not in params:
        return error_response(400, "Missing image ID")

    image_id = params['id']
    width = int(params.get('width', 300))
    height = int(params.get('height', 300))

    try:
        image_bytes = s3.get_object(
            Bucket=os.environ['BUCKET_NAME'],
            Key=image_id
        )['Body'].read()

        img = Image.open(io.BytesIO(image_bytes))
        img.thumbnail((width, height))

        output = io.BytesIO()
        img.save(output, format='JPEG')
        return {
            'statusCode': 200,
            'headers': {'Content-Type': 'image/jpeg'},
            'body': output.getvalue().hex(),
            'isBase64Encoded': True
        }
    except Exception as e:
        return error_response(404, f"Image not found: {str(e)}")


def handle_post(event):
    if len(event['body']) > int(os.environ['MAX_IMAGE_SIZE']):
        return error_response(413, "Image too large")

    try:
        image_bytes = bytes.fromhex(event['body'])
        image_id = str(uuid.uuid4())

        s3.put_object(
            Bucket=os.environ['BUCKET_NAME'],
            Key=image_id,
            Body=image_bytes,
            ContentType='image/jpeg'
        )
        return {
            'statusCode': 200,
            'body': image_id
        }
    except Exception as e:
        return error_response(400, f"Invalid image: {str(e)}")


def error_response(code, message):
    return {
        'statusCode': code,
        'body': message
    }