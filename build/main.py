import asyncio
from pathlib import Path
import re
import shutil
from util import consol, json, cmd


class Target:
    def __init__(self, flutter_name: str, title: str, package: str, version: str, team: str, profile: str, signing: str, build: list[str]):
        self.flutter_name = flutter_name
        self.title = title
        self.package = package
        self.version = version
        self.team = team
        self.profile = profile
        self.signing = signing
        self.build = build


class Project:
    def __init__(self, path: str, name: str, flutter_name: str, package: str, title: str, profile: str, signing: str, team: str):
        self.path = path
        self.name = name
        self.flutter_name = flutter_name
        self.package = package
        self.title = title
        self.profile = profile
        self.signing = signing
        self.team = team


class BuildConfig:
    def __init__(self, target: dict, project: dict):
        self.target = Target(**target)
        self.project = Project(**project)

    def __repr__(self):
        return f"BuildConfig(target={self.target}, project={self.project})"
    
    @staticmethod
    def from_json(json_data) -> 'BuildConfig':
        return BuildConfig(json_data['target'], json_data['project'])

def main():
    works_path = Path.cwd() / "works"

    if not works_path.exists():
        consol.error('没有找到工作文件夹, 程序退出...')
        return

    asyncio.run(run_tasks(works_path))

async def run_tasks(path: Path):
    works = path.iterdir()

    if not works:
        consol.error('没有找到任何任务, 程序退出...')
        return
    else:
        consol.log(f'一共 {len(list(works))} 个任务需要处理')

    tasks = []
    index = 0
    print("正在处理任务...")
    for work in path.iterdir():
        index += 1
        tasks.append(build(work, index))

    await asyncio.gather(*tasks)

async def build(path: Path, index: int):
    consol.log(f'正在处理第 {index} 个任务 -> {path}')

    json_path = path / "config.json"
    resource_path = path / "resource"
    export_options_path = path / "ExportOptions.plist"

    if not path.is_dir():
        consol.error('不是文件夹, 跳过处理...')
        return

    if json_path not in path.iterdir():
        consol.error('没有找到config.json配置文件, 跳过处理...')
        return

    if resource_path not in path.iterdir():
        consol.error('没有找到resource资源文件夹, 跳过处理...')
        return
    
    if export_options_path not in path.iterdir():
        consol.error('没有找到ExportOptions.plist导出配置文件, 跳过处理...')
        return

    # 读取 config.json 文件
    config_file = json.read(str(json_path))
    config = BuildConfig.from_json(config_file)
    consol.succful(f"加载配置文件成功: {config_file}")

    # 项目目录
    project_path = path / config.project.name

    if project_path.exists():
        shutil.rmtree(project_path)

    # 复制项目
    shutil.copytree(Path(config.project.path), project_path)

    # 更新项目名称 和 版本号
    update_yaml(project_path, config)

    # 更新 dart 文件
    update_dart(project_path / "lib", config)
    update_dart(project_path / "test", config)

    # 更新 Android 文件
    update_android(path, config)

    # 更新 IOS 文件
    update_ios(path, config)

    # 更新资源文件
    update_assets(path, config)

    print()
    consol.log('正在打包...')
    print()

    ios_path = project_path / "ios"
    build_path = project_path / "build"

    cmd.run("flutter clean", cwd=project_path)
    cmd.run("flutter pub get", cwd=project_path)
    cmd.run("pod install", cwd=ios_path)

    envs = config.target.build

    env_index = 0
    for env in envs:
        env_index += 1
        print()
        print(f"正在处理 {env_index} / {len(envs)} 个环境 -> {env}")
        print()

        environment = "--dart-define=ENVIRONMENT=%s" % env

        cmd.run("flutter build ios -v --release --no-codesign %s" % (environment), cwd=project_path)

        archive_path = build_path / "ios/archive/Runner.xcarchive"

        # 使用xcodebuild命令创建项目归档和导出IPA文件
        cmd.run(f"xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release archive -archivePath {archive_path} -destination 'generic/platform=iOS'", cwd=project_path)
        cmd.run(f"xcodebuild -exportArchive -archivePath {archive_path} -exportOptionsPlist {export_options_path} -exportPath {path}", cwd=project_path)

        # 重命名 IPA 文件
        old_ipa_path = path / f'{config.target.flutter_name}.ipa'
        new_ipa_path = path / f'{config.target.title}_{env}.ipa'
        old_ipa_path.rename(new_ipa_path)

        cmd.run("flutter build apk -v --release %s"  % (environment), cwd=project_path)
        old_apk_path =  "app/outputs/flutter-apk/app-release.apk"
        new_apk_path = path / f'{config.target.title}_{env}.apk'

        shutil.copy(build_path / old_apk_path, path / new_apk_path)

    summary_path = path / "DistributionSummary.plist"
    if summary_path.exists():
        summary_path.unlink()

    packaging_log_path = path / "Packaging.log"
    if packaging_log_path.exists():
        packaging_log_path.unlink()

    shutil.rmtree(project_path)

    consol.log(f'✅✅✅ 第 {index} 个任务处理完毕 -> {path}')

def update_assets(path: Path, config: BuildConfig):
    consol.log('正在更新资源文件...')
    stc_path = path / 'resource/assets'
    dst_path = path / config.project.name / 'assets'

    if dst_path.exists():
        consol.log('资源文件夹已存在，正在删除...')
        shutil.rmtree(dst_path)
    
    shutil.copytree(stc_path, dst_path)
    consol.succful('资源文件夹更新成功...')


def update_yaml(path: Path, config: BuildConfig):
    consol.log('正在更新 YAML 文件...')
    pubspec_path = path / 'pubspec.yaml'

    if config.target.flutter_name == "" and config.target.version == "":
        consol.log("name 和 version 为空，不需要替换")
        return
    
    if not pubspec_path.exists():
        consol.log("pubspec.yaml 文件不存在")
        return

    with open(pubspec_path, 'r', encoding='utf-8') as file:
        content = file.read()

    new_content = content
    
    if config.target.version != "":
        new_content = re.sub(r'version: \d+\.\d+\.\d+', f'version: {config.target.version}', content)
    
    if config.target.flutter_name != "":
        name_without_quotes = config.target.flutter_name.strip('"').strip("'")
        new_content = re.sub(r'name:\s*\S+', f'name: {name_without_quotes}', new_content)

    if new_content != content:
        with open(pubspec_path, 'w', encoding='utf-8') as file:
            file.write(new_content)

    consol.log(f"已更新 {pubspec_path} 文件中的 name 和 version")

def update_android(path: Path, config: BuildConfig):
    """更新 Android 文件"""
    consol.log('正在更新 Android 文件...')
    android_path = path / config.project.name / "android/app"
    kotlin_path = android_path / "src/main/kotlin"

    old_package_path = kotlin_path / Path(*config.project.package.split("."))
    new_package_path = kotlin_path / Path(*config.target.package.split("."))

    if old_package_path.exists():
        shutil.move(str(old_package_path), str(new_package_path))

    remove_empty_dirs(kotlin_path)

    for item in new_package_path.iterdir():
        if item.suffix == '.kt':
            with item.open('r', encoding='utf-8') as file:
                content = file.read()

            new_content = content.replace(config.project.package, config.target.package)

            with item.open('w', encoding='utf-8') as file:
                file.write(new_content)

            consol.succful(f"KT 文件修改成功 --> {item}")

    # 更新 AndroidManifest.xml
    manifest_path = android_path / "src/main/AndroidManifest.xml"
    with open(manifest_path, "r+", encoding="utf-8") as file:
        content = file.read()

        content = content.replace(config.project.package, config.target.package)

        if config.target.title != "":
            pattern = r'android:label="(.*?)"'
            replacement = f'android:label="{config.target.title}"'
            content = re.sub(pattern, replacement, content)

        file.seek(0)
        file.write(content)
        file.truncate()
    consol.log(f"AndroidManifest.xml 包名已更新为 {config.target.package}")

    # 更新 build.gradle
    gradle_path = android_path / "build.gradle"
    with open(gradle_path, "r+", encoding="utf-8") as file:
        content = file.read()

        content = content.replace(config.project.package, config.target.package)

        file.seek(0)
        file.write(content)
        file.truncate()
    consol.log("build.gradle 包名已更新")

    # 更新资源文件
    resource_path = path / "resource/android"

    launch_image = "launch_image.png"
    launch_image_path = android_path / "src/main/res/mipmap"
    launch_image_path.mkdir(parents=True, exist_ok=True)
    shutil.copy(resource_path / "mipmap" / launch_image, launch_image_path / launch_image)

    ic_launcher = "ic_launcher.png"

    hdpi_path = android_path / "src/main/res/mipmap-hdpi"
    ldpi_path = android_path / "src/main/res/mipmap-ldpi"
    mdpi_path = android_path / "src/main/res/mipmap-mdpi"
    xhdpi_path = android_path / "src/main/res/mipmap-xhdpi"
    xxhdpi_path = android_path / "src/main/res/mipmap-xxhdpi"
    xxxhdpi_path = android_path / "src/main/res/mipmap-xxxhdpi"

    hdpi_path.mkdir(parents=True, exist_ok=True)
    ldpi_path.mkdir(parents=True, exist_ok=True)
    mdpi_path.mkdir(parents=True, exist_ok=True)
    xhdpi_path.mkdir(parents=True, exist_ok=True)
    xxhdpi_path.mkdir(parents=True, exist_ok=True)
    xxxhdpi_path.mkdir(parents=True, exist_ok=True)


    shutil.copy(resource_path / "mipmap-hdpi" / ic_launcher, hdpi_path / ic_launcher)
    shutil.copy(resource_path / "mipmap-ldpi" / ic_launcher, ldpi_path / ic_launcher)
    shutil.copy(resource_path / "mipmap-mdpi" / ic_launcher, mdpi_path / ic_launcher)
    shutil.copy(resource_path / "mipmap-xhdpi" / ic_launcher, xhdpi_path / ic_launcher)
    shutil.copy(resource_path / "mipmap-xxhdpi" / ic_launcher, xxhdpi_path / ic_launcher)
    shutil.copy(resource_path / "mipmap-xxxhdpi" / ic_launcher, xxxhdpi_path / ic_launcher)

    consol.succful("✅ Android 资源文件已更新 ....")

def remove_empty_dirs(path: Path):
    for child in path.iterdir():
        if child.is_dir():
            remove_empty_dirs(child)

    if not any(path.iterdir()):
        path.rmdir()
        consol.log(f"删除了空文件夹 {path}")

def update_dart(path: Path, config: BuildConfig):
    consol.log('正在更新 Dart 文件...')

    for item in path.iterdir():
        if item.is_dir():
            update_dart(item, config)
        elif item.suffix == '.dart' and item.name != "channel.dart":
            with item.open('r', encoding='utf-8') as file:
                content = file.read()

            if config.target.package != "":
                new_content = content.replace(config.project.package, config.target.package)

            if config.target.title != "":
                new_content = new_content.replace(config.project.title, config.target.package)

            if config.target.flutter_name != "":
                new_content = new_content.replace(config.project.flutter_name, config.target.flutter_name)


            with item.open('w', encoding='utf-8') as file:
                file.write(new_content)

            consol.succful(f"dart 文件修改成功 --> {item}")

def update_ios(path: Path, config: BuildConfig):
    consol.log('正在更新 IOS 文件...')

    ios_path = path / config.project.name / "ios"
    plist_path = ios_path / "Runner" / "Info.plist"
    pbxproj_path = ios_path / "Runner.xcodeproj" / "project.pbxproj"

    with open(plist_path, "r+", encoding="utf-8") as file:
        content = file.read()
        content = content.replace(config.project.package, config.target.package)


        if config.target.title != "":
            pattern = r'(<key>CFBundleDisplayName</key>\s*<string>)(.*?)(</string>)'
            replacement = r'\1' + config.target.title + r'\3'
            content = re.sub(pattern, replacement, content)

        if config.target.flutter_name != "":
            pattern = r'(<key>CFBundleName</key>\s*<string>)(.*?)(</string>)'
            replacement = r'\1' + config.target.flutter_name + r'\3'
            content = re.sub(pattern, replacement, content)

        file.seek(0)
        file.write(content)
        file.truncate()
    consol.log(f"Info.plist 包名已更新为 {config.target.package}")

    with open(pbxproj_path, "r+", encoding="utf-8") as file:
        content = file.read()
        content = content.replace(config.project.package, config.target.package)
        content = content.replace(config.project.profile, config.target.profile)
        content = content.replace(config.project.team, config.target.team)
        content = content.replace(config.project.signing, config.target.signing)
        
        file.seek(0)
        file.write(content)
        file.truncate()
    consol.log(f"project.pbxproj 已更新为 {config.target.profile}")

    with open(path / "ExportOptions.plist", "r+", encoding="utf-8") as file:
        content = file.read()


        pattern = r'(<key>provisioningProfiles</key>\s*<dict>\s*<key>)(.*?)(</key>)'
        replacement = r'\1' + config.target.package + r'\3'

        content = re.sub(pattern, replacement, content)

        file.seek(0)
        file.write(content)
        file.truncate()
    consol.log(f"ExportOptions.plist 包名已更新为 {config.target.package}")

    resource_path = path / "resource/ios"
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


if __name__ == "__main__":
    main()

