from pathlib import Path
import re
from flutter.models.config import BuildConfig
from utils import consol

def run(path: Path, config: BuildConfig):
    with open(path / "ExportOptions.plist", "r+", encoding="utf-8") as file:
        content = file.read()

        if config.target.package != "":
            pattern = r'(<key>provisioningProfiles</key>\s*<dict>\s*<key>)(.*?)(</key>)'
            replacement = r'\1' + config.target.package + r'\3'
            content = re.sub(pattern, replacement, content)

        file.seek(0) 
        file.write(content)
        file.truncate()

        print()
        consol.succful(f"ExportOptions.plist 包名已更新为 {config.target.package}")