# from algoliasearch.search_client import SearchClient

from algoliasearch.search_client import SearchClient  # type: ignore
import json
import logging
import requests  # type: ignore


def handler(event, context):
    for record in event["Records"]:
        print(record["eventID"])
        print(record["eventName"])
    print("Successfully processed %s records." % str(len(event["Records"])))
    url = "https://dashboard.algolia.com/sample_datasets/movie.json"
    records = requests.get(url).json()

    # Connect and authenticate with your Algolia app
    client = SearchClient.create("QPF09AOZQE", "85d91dc4f7b75dbd3299217a3dc7905e")

    # Create a new index. An index stores the data that you want to make searchable in Algolia.
    index = client.init_index("your_index_name")

    try:
        index.save_objects(
            records,
            {
                # set autoGenerateObjectIDIfNotExist to false if your records contain an ObjectID
                "autoGenerateObjectIDIfNotExist": True
            },
        )
    except Exception as e:
        logging.error(str(e))
