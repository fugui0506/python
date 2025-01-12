from pathlib import Path
import re
from flutter.models.config import BuildConfig
from utils import consol

def run(path: Path, config: BuildConfig):
    print()
    consol.log('正在更新 YAML 文件...')

    pubspec_path = path / 'pubspec.yaml'
    if pubspec_path.exists():
        with open(pubspec_path, 'r+', encoding='utf-8') as file:
            content = file.read()
            
            if config.target.version != "":
                content = re.sub(r'version: \d+\.\d+\.\d+', f'version: {config.target.version}', content)

            file.seek(0) 
            file.write(content)
            file.truncate()

            consol.succful(f"已更新YAML文件 -> {pubspec_path}")

    shorebird_path = path / 'shorebird.yaml'
    if shorebird_path.exists():
        with open(shorebird_path, 'r+', encoding='utf-8') as file:
            content = file.read()
            
            if config.target.shorebird_id != "":
                content = re.sub(r'app_id:\s*\S+', f'app_id: {config.target.shorebird_id}', content)

            file.seek(0) 
            file.write(content)
            file.truncate()

            consol.succful(f"已更新ShoreBird文件 -> {shorebird_path}")