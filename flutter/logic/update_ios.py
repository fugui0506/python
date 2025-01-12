import shutil
from pathlib import Path
from flutter.models.config import BuildConfig
from utils import consol

def run(path: Path, config: BuildConfig, resource: Path):
    print()

    ios_path = path / "ios"
    pbxproj_path = ios_path / "Runner.xcodeproj" / "project.pbxproj"

    consol.log(f'正在更新 IOS 文件 -> {ios_path}')

    with open(pbxproj_path, "r+", encoding="utf-8") as file:
        content = file.read()
        
        if config.target.profile != "" and config.project.profile != "" and config.target.profile != config.project.profile:
            content = content.replace(config.project.profile, config.target.profile)
        
        if config.target.team != "" and config.project.team != "" and config.target.team != config.project.team:
            content = content.replace(config.project.team, config.target.team)

        if config.target.signing != "" and config.project.signing != "" and config.target.signing != config.project.signing:
            content = content.replace(config.project.signing, config.target.signing)
        
        file.seek(0) 
        file.write(content)
        file.truncate()

        consol.succful(f"project.pbxproj 已更新为 {config.target.profile}")
    
    resource_path = resource / "ios"

    if resource_path.exists():
        shutil.copy(resource_path / "AppIcon.appiconset/Contents.json", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/Contents.json")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-20@2x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-20@2x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-20@3x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-20@3x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-29@2x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-29@2x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-29@3x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-29@3x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-38@2x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-38@2x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-38@3x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-38@3x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-40@2x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-40@2x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-40@3x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-40@3x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-60@2x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-60@2x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-60@3x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-60@3x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-64@2x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-64@2x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-64@3x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-64@3x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-68@2x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-68@2x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-76@2x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-76@2x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-83.5@2x.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-83.5@2x.png")
        shutil.copy(resource_path / "AppIcon.appiconset/icon-1024.png", ios_path / "Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png")

        shutil.copy(resource_path / "LaunchImage.imageset/LaunchImage.png", ios_path / "Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png")
        shutil.copy(resource_path / "LaunchImage.imageset/LaunchImage@2x.png", ios_path / "Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png")
        shutil.copy(resource_path / "LaunchImage.imageset/LaunchImage@3x.png", ios_path / "Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png")

        consol.succful("✅ IOS 资源文件已更新 ....")
