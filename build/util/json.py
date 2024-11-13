import json


def read(path: str):

    with open(path) as file:
        data = json.loads(file.read().strip())
    file.close()

    return data