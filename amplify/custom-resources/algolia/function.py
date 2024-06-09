from algoliasearch.search_client import SearchClient

from __future__ import print_function


def lambda_handler(event, context):
    for record in event["Records"]:
        print(record["eventID"])
        print(record["eventName"])
    print("Successfully processed %s records." % str(len(event["Records"])))
