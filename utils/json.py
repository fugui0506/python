import json
from utils import consol

def read(path: str):
    print()
    consol.log(f"正在读取文件的内容 -> {path}")

    with open(path) as file:
        data = json.loads(file.read().strip())

    consol.succful(f"文件的内容: {dumps(data)}")
    return data

def dumps(data: dict) -> str:
    return json.dumps(data, indent=4)