import json
from pathlib import Path
import re
import shutil
import subprocess
from tqdm import tqdm

BUILD_ENVS: list[str] = ['test', 'rel', 'pre', 'grey']

class Config:
    def __init__(self, **kwargs):
        self.name: str = kwargs.get("name", "")
        self.flutter_name: str = kwargs.get("flutter_name", "")
        self.title: str = kwargs.get("title", "")
        self.package: str = kwargs.get("package", "")
        self.version: str = kwargs.get("version", "")
        self.team: str = kwargs.get("team", "")
        self.profile: str = kwargs.get("profile", "")
        self.signing: str = kwargs.get("signing", "")
        self.path: str = kwargs.get("path", "")
        self.shorebird_id: str = kwargs.get("shorebird_id", "")

    def to_json(self):
        return self.__dict__

class BuildConfig:
    def __init__(self, target: dict, project: dict):
        self.target = Config(**target)
        self.project = Config(**project)

    @staticmethod
    def from_json(json_data):
        return BuildConfig(json_data['target'], json_data['project'])

    def to_json(self):
        return {"target": self.target.to_json(), "project": self.project.to_json()}

def main():
    works_path = Path(__file__).resolve().parent
    build(works_path)

def build(path: Path):
    build_envs = get_build_envs()

    json_path = path / "config.json"
    export_options_path = path / "ExportOptions.plist"

    if json_path not in path.iterdir():
        print('没有找到config.json配置文件, 跳过处理...')
        return
    
    if export_options_path not in path.iterdir():
        print('没有找到ExportOptions.plist导出配置文件, 跳过处理...')
        return
    
    with open(json_path, 'r') as file:
        config_file = json.loads(file.read().strip())
        config = BuildConfig.from_json(config_file)

    print()
    print(f"加载配置文件成功: {config.to_json}")

    # 项目目录
    if config.target.name != "":
        project_path = path / str(config.target.name)
    else:
        project_path = path / 'project'
        config.target.name = project_path.name

    if project_path.exists():
        shutil.rmtree(project_path)
        print()
        print(f"删除文件夹成功: {project_path}")

    # 复制项目文件
    copy_project(config.project.path, project_path)

    # 设置配置参数
    set_config_project(project_path, config)

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
    print('正在打包...')
    print()

    ios_path = project_path / "ios"

    shell("flutter clean", cwd=project_path)
    shell("flutter pub get", cwd=project_path)
    shell("pod install", cwd=ios_path)

    env_index = 0
    for env in build_envs:
        env_index += 1
        print()
        print(f"正在处理 {env_index} / {len(build_envs)} 个环境 -> {env}")
        print()

        environment = "--dart-define=ENVIRONMENT=%s" % env

        shell("yes '' | shorebird patch ios --no-codesign %s --verbose"  % (environment), cwd=project_path)
        shell("yes '' | shorebird patch android %s --verbose" % (environment), cwd=project_path)

    summary_path = path / "DistributionSummary.plist"
    if summary_path.exists():
        summary_path.unlink()

    packaging_log_path = path / "Packaging.log"
    if packaging_log_path.exists():
        packaging_log_path.unlink()

    shutil.rmtree(project_path)

    print(f'✅✅✅ 任务处理完毕 -> {path}')

def copy_project(src_path: Path, dst_path: Path):
    # 复制项目
    print(f"正在复制文件夹 {src_path} -> {dst_path}")

    files = list(Path(src_path).rglob('*'))
    print(f"文件总数: {len(files)}")
    with tqdm(total=len(files), desc="Copying files") as pbar:
        for item in files:
            target_path = dst_path / item.relative_to(src_path)

            # 确保目标路径的父目录存在
            if not target_path.parent.exists():
                print(f"创建父目录: {target_path.parent}")
                target_path.parent.mkdir(parents=True, exist_ok=True)

            if item.is_dir():
                target_path.mkdir(parents=True, exist_ok=True)
            else:
                shutil.copy2(item, target_path)
            pbar.update(1)

    # shutil.copytree(Path(config.project.path), project_path)
    print(f"文件夹复制成功: {dst_path}")

def set_config_project(path: Path, config: BuildConfig):
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

        match = re.search(r'namespace\s+"([\w.]+)"', content)
        if match:
            config.project.package = match.group(1)

    xml_path = path / "android/app/src/main/AndroidManifest.xml"
    with open(xml_path, 'r') as file:
        content = file.read()

        match = re.search(r'<application[^>]*\sandroid:label=["\']([^"\']+)["\']', content)
        if match:
            config.project.title = match.group(1)
    print('项目配置成功... %s' % config.project.to_json())

def update_assets(path: Path, config: BuildConfig):
    print('正在更新资源文件...')
    src_path = path / 'resource/assets'
    dst_path = path / config.target.name / 'assets'

    if dst_path.exists() and src_path.exists():
        print('资源文件夹已存在，正在删除...')
        shutil.rmtree(dst_path)
        shutil.copytree(src_path, dst_path)
        print('资源文件夹更新成功...')


def update_yaml(path: Path, config: BuildConfig):
    print('正在更新 YAML 文件...')

    pubspec_path = path / 'pubspec.yaml'
    if pubspec_path.exists():
        with open(pubspec_path, 'r+', encoding='utf-8') as file:
            content = file.read()
            
            if config.target.version != "":
                content = re.sub(r'version: \d+\.\d+\.\d+', f'version: {config.target.version}', content)
            
            if config.target.flutter_name != "":
                name_without_quotes = config.target.flutter_name.strip('"').strip("'")
                content = re.sub(r'name:\s*\S+', f'name: {name_without_quotes}', content)

            file.seek(0) 
            file.write(content)
            file.truncate()

            print(f"已更新YAML文件 -> {pubspec_path}")

    shorebird_path = path / 'shorebird.yaml'
    if shorebird_path.exists():
        with open(shorebird_path, 'r+', encoding='utf-8') as file:
            content = file.read()
            
            if config.target.shorebird_id != "":
                content = re.sub(r'app_id:\s*\S+', f'app_id: {config.target.shorebird_id}', content)

            file.seek(0) 
            file.write(content)
            file.truncate()

            print(f"已更新YAML文件 -> {pubspec_path}")

def update_android(path: Path, config: BuildConfig):
    """更新 Android 文件"""

    if config.target.package == "":
        return

    print('正在更新 Android 文件...')
    android_path = path / config.target.name / "android/app"
    kotlin_path = android_path / "src/main/kotlin"

    old_package_path = kotlin_path / Path(*config.project.package.split("."))
    new_package_path = kotlin_path / Path(*config.target.package.split("."))

    if old_package_path.exists():
        shutil.move(str(old_package_path), str(new_package_path))

    remove_empty_dirs(kotlin_path)

    for item in new_package_path.iterdir():
        if item.suffix == '.kt':
            with item.open('r+', encoding='utf-8') as file:
                content = file.read()

                content = content.replace(config.project.package, config.target.package)

                file.seek(0)
                file.write(content)
                file.truncate()


            print(f"KT 文件修改成功 --> {item}")

    # 更新 AndroidManifest.xml
    manifest_path = android_path / "src/main/AndroidManifest.xml"
    with open(manifest_path, "r+", encoding="utf-8") as file:
        content = file.read()

        if config.target.package != "":
            content = content.replace(config.project.package, config.target.package)

        if config.target.title != "":
            pattern = r'android:label="(.*?)"'
            replacement = f'android:label="{config.target.title}"'
            content = re.sub(pattern, replacement, content)


        file.seek(0) 
        file.write(content)
        file.truncate()
        print(f"AndroidManifest.xml 包名已更新为 {config.target.package}")

    # 更新 build.gradle
    gradle_path = android_path / "build.gradle"
    with open(gradle_path, "r+", encoding="utf-8") as file:
        content = file.read()

        if config.target.package != "":
            content = content.replace(config.project.package, config.target.package)

        file.seek(0) 
        file.write(content)
        file.truncate()
        print("build.gradle 包名已更新")

    # 更新资源文件
    resource_path = path / "resource/android"

    if resource_path.exists():
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

        print("✅ Android 资源文件已更新 ....")

def remove_empty_dirs(path: Path):
    for child in path.iterdir():
        if child.is_dir():
            remove_empty_dirs(child)

    if not any(path.iterdir()):
        path.rmdir()
        print(f"删除了空文件夹 {path}")

def update_dart(path: Path, config: BuildConfig):
    """
    更新 Dart 文件中的 package、title 和 flutter_name。
    遍历指定路径下的所有 Dart 文件，并进行内容替换。
    """
    print(f'正在更新 Dart 文件: {path.resolve()}')

    if not path.exists() or not path.is_dir():
        print(f'路径不存在或不是文件夹: {path}')
        return

    # 递归获取所有 .dart 文件
    for dart_file in path.rglob('*.dart'):
        print(f'正在处理 Dart 文件 -> {dart_file.resolve()}')

        with dart_file.open('r+', encoding='utf-8') as file:
            content = file.read()

            # 替换包名
            if config.target.package != "":
                content = content.replace(config.project.package, config.target.package)

            # 替换标题
            if config.target.title != "":
                content = content.replace(config.project.title, config.target.title)

            # 替换 Flutter 名称
            if config.target.flutter_name != "":
                content = content.replace(config.project.flutter_name, config.target.flutter_name)

            file.seek(0) 
            file.write(content)
            file.truncate()

            print(f'Dart 文件修改成功 --> {dart_file.resolve()}')

def update_ios(path: Path, config: BuildConfig):
    print('正在更新 IOS 文件...')

    ios_path = path / config.target.name / "ios"
    plist_path = ios_path / "Runner" / "Info.plist"
    pbxproj_path = ios_path / "Runner.xcodeproj" / "project.pbxproj"

    with open(plist_path, "r+", encoding="utf-8") as file:
        content = file.read()

        if config.target.package != "":
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

        print(f"Info.plist 包名已更新为 {config.target.package}")

    with open(pbxproj_path, "r+", encoding="utf-8") as file:
        content = file.read()

        if config.target.package != "":
            content = content.replace(config.project.package, config.target.package)
        
        if config.target.profile != "":
            content = content.replace(config.project.profile, config.target.profile)
        
        if config.target.team != "":
            content = content.replace(config.project.team, config.target.team)

        if config.target.signing != "":
            content = content.replace(config.project.signing, config.target.signing)
        

        file.seek(0) 
        file.write(content)
        file.truncate()

        print(f"project.pbxproj 已更新为 {config.target.profile}")

    with open(path / "ExportOptions.plist", "r+", encoding="utf-8") as file:
        content = file.read()

        if config.target.package != "":
            pattern = r'(<key>provisioningProfiles</key>\s*<dict>\s*<key>)(.*?)(</key>)'
            replacement = r'\1' + config.target.package + r'\3'
            content = re.sub(pattern, replacement, content)


        file.seek(0) 
        file.write(content)
        file.truncate()

        print(f"ExportOptions.plist 包名已更新为 {config.target.package}")

    resource_path = path / "resource/ios"
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

def shell(command, cwd=None):
    """
    辅助函数，用于运行Shell命令并打印其输出。
    如果命令执行失败，抛出异常并打印错误信息。
    """
    print("=" * 120)
    print("运行命令: %s" % command)
    print("命令路径: %s" % cwd)

    # 执行命令并获取stdout和stderr
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)
    
    # 捕获输出并逐行打印
    stdout_lines = []
    stderr_lines = []
    
    # 逐行读取并打印stdout和stderr的内容
    for stdout_line in iter(process.stdout.readline, b''):
        decoded_line = stdout_line.decode('utf-8')
        stdout_lines.append(decoded_line)
        print(decoded_line, end='')  # 实时打印标准输出

    for stderr_line in iter(process.stderr.readline, b''):
        decoded_line = stderr_line.decode('utf-8')
        stderr_lines.append(decoded_line)
        print(decoded_line, end='')  # 实时打印错误输出

    process.stdout.close()
    process.stderr.close()
    process.wait()

    if process.returncode != 0:
        raise subprocess.CalledProcessError(process.returncode, command, output="".join(stderr_lines))

    print("=" * 120)

def get_build_envs() -> list[str]:
    input_str = input("==> 请输入打包环境,多个环境用逗号隔开(如: test, rel):  ")
    input_str = input_str.replace(' ', '')
    build_envs = input_str.split(',')

    index = 0
    while index < len(build_envs):
        if build_envs[index] not in BUILD_ENVS:
            print(f"{build_envs[index]} -> 不支持的打包环境")
            build_envs.remove(build_envs[index])
        else:
            index += 1
    
    build_envs = list(set(build_envs))

    if (len(build_envs) == 0):
        build_envs = ['test']
    
    print("\n==> 开始打包 %s \n" % (build_envs))

    return build_envs

if __name__ == "__main__":
    main()