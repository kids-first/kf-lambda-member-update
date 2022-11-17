from json import loads

def transform_event_to_docs(event, index, omit):
    """
    Takes an event and transform it to a suitable doc for the elastic search client.
    Arguments:
      event: service event – Amazon SNS notification
      index: the elastic search index name where that doc will be written to.
      omit: list of fields that we want to omit
    Returns:
      a generator with docs"""
    for record in event["Records"]:
        payload = loads(record["body"])
        yield dict(
            filter(
                lambda x: x[0] not in omit if len(omit) > 0 else True,
                {
                    "_index": index,
                    "_id": payload["_id"],
                    "firstName": payload.get("firstName"),
                    "lastName": payload.get("lastName"),
                    "email": payload.get("email"),
                    "hashedEmail": payload.get("hashedEmail"),
                    "institutionalEmail": payload.get("institutionalEmail"),
                    "acceptedTerms": payload.get("acceptedTerms"),
                    "isPublic": payload.get("isPublic", False),
                    "isActive": payload.get("isActive", True),
                    "roles": payload.get("roles"),
                    "title": payload.get("title"),
                    "jobTitle": payload.get("jobTitle"),
                    "institution": payload.get("institution"),
                    "city": payload.get("city"),
                    "state": payload.get("state"),
                    "country": payload.get("country"),
                    "eraCommonsID": payload.get("eraCommonsID"),
                    "bio": payload.get("bio"),
                    "story": payload.get("story"),
                    "interests": payload.get("interests"),
                    "virtualStudies": payload.get("virtualStudies"),
                    "searchableInterests": [
                        {"name": p} for p in (payload.get("interests") or [])
                    ],
                    "linkedin": payload.get("linkedin", ""),
                    "website": payload.get("website", ""),
                }.items(),
            )
        )