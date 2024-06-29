import os
import logging
import requests

log = logging.getLogger(__name__)
log.setLevel('INFO')
log.info(f'Running - {os.getenv('AWS_LAMBDA_FUNCTION_NAME')}')


def handler(event, context):

    endpoint = "https://api.consigncloud.com/api/v1/accounts"
    data = {"ip": "1.1.2.3"}
    headers = {"Authorization": "Bearer YWI3YWViMGItYWIwMS00YTcyLWI0ODktYzZhYzdhYTEyMTlmOnZsN0UybnZpaTdPYldIb0QwdFF5bVE="}

    print(requests.get(endpoint, headers=headers).json())
