from pathlib import Path
import re
from flutter.models.config import BuildConfig
from utils import consol, json


def run(path: Path, config: BuildConfig):
    yaml_path = path / "pubspec.yaml"
    with open(yaml_path, 'r') as file:
        content = file.read()

        match = re.search(r'version:\s*([^\s]+)', content)
        if match:
            config.project.version = match.group(1)
        
        match = re.search(r'name:\s*([^\s]+)', content)
        if match:
            config.project.flutter_name = match.group(1)

    shorebird = path / "shorebird.yaml"
    with open(shorebird, 'r') as file:
        content = file.read()

        match = re.search(r'app_id:\s*([^\s]+)', content)
        if match:
            config.project.shorebird_id = match.group(1)

    gradle_path = path / "android/app/build.gradle"
    with open(gradle_path, 'r') as file:
        content = file.read()

        match = re.search(r'(namespace\s*=\s*"([\w.]+)"|applicationId\s+"([\w.]+))', content)
    
        if match:
            # 获取 namespace 或 applicationId 的值
            package_name = match.group(2) if match.group(2) else match.group(3)
            config.project.package = package_name

    xml_path = path / "android/app/src/main/AndroidManifest.xml"
    with open(xml_path, 'r') as file:
        content = file.read()

        match = re.search(r'<application[^>]*\sandroid:label=["\']([^"\']+)["\']', content)
        if match:
            config.project.title = match.group(1)

    print()
    consol.succful('项目配置成功... %s' % json.dumps(config.project.to_json()))