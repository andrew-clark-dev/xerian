import os
import logging

log = logging.getLogger(__name__)
log.setLevel('INFO')
log.info(f'Running - {os.getenv('AWS_LAMBDA_FUNCTION_NAME')}')


def handler(event, context):
    print(event)

