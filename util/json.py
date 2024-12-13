import json


def read(path: str):

    with open(path) as file:
        data = json.loads(file.read().strip())
    return data