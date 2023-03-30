"""
To run this script you need an elasticsearch cluster.
This script is not meant to used by the lambda.
It is useful for maintenance.
"""
from os import environ
import app
import mappings

PIPELINE_ID = "member"


def print_red(text):
    print(f"\033[91m{text}\033[00m")


def main():
    """
    This script copies (reIndex) documents from member index to members index.
    Assumes that the destination index DOES NOT EXIST.
    """
    es_client = app.build_es_client(
        environ.get("es_host", "elasticsearch"),
        environ.get("es_port", "9200"),
        environ.get("es_scheme", "http"),
    )

    if not es_client.indices.exists(index=mappings.INDEX_MEMBER):
        print_red(f"source index {mappings.INDEX_MEMBER} does not exist. Terminating.")
        return

    if es_client.indices.exists(index=mappings.INDEX_MEMBERS):
        print_red(
            f"This script assumes that the index {mappings.INDEX_MEMBERS} does not exist."
            " Alas, it exists. Terminating."
        )
        return

    es_client.indices.create(
        mappings.INDEX_MEMBERS, body=mappings.INDEX_TO_MAPPING[mappings.INDEX_MEMBERS]
    )

    es_client.ingest.put_pipeline(
        PIPELINE_ID,
        {
            "description": "Removes the 'virtualStudies' field",
            "processors": [
                {"remove": {"field": "virtualStudies", "ignore_missing": True}}
            ],
        },
    )

    es_client.reindex(
        {
            "source": {
                "index": mappings.INDEX_MEMBER,
            },
            "dest": {"index": mappings.INDEX_MEMBERS, "pipeline": PIPELINE_ID},
        }
    )

    es_client.ingest.delete_pipeline(PIPELINE_ID)

    es_client.indices.put_alias(
        mappings.INDEX_MEMBERS,
        mappings.PUBLIC_MEMBERS_ALIAS,
        body={
            "actions": [
                {
                    "add": {
                        "index": mappings.INDEX_MEMBERS,
                        "filter": {
                            "bool": {"filter": [{"term": {"isPublic": True}}]}
                        },
                    }
                }
            ]
        },
    )


if __name__ == "__main__":
    main()
