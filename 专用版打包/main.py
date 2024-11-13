
from asyncio import subprocess
import json
from pathlib import Path
import shutil
import subprocess

JSON_FILE: str = 'config.json'

# 项目文件夹的名称
PROJEECT_NAME: str = 'wallet-flutter-app'
PROJEECT_PATH: str = 'documents/projects'

BUILD_ENVS: list[str] = ['test', 'rel', 'pre', 'grey']

MAIN_PATH = Path.cwd()

# 旧项目包名
OLD_PACKAGE_NAME: str = 'com.cgwallet.app.cgwallet'
OLD_PROFILE: str = 'cgwalletAPNS_dev'
OLD_TEAM_ID: str = 'N93BC5TDK8'
OLD_SIGNING: str = 'iPhone Developer'

def main():
    input_str = input("==> 请输入打包环境,多个环境用逗号隔开(如: test, rel):  ")
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

    # 项目目录
    old_project_path = Path.home() / PROJEECT_PATH / PROJEECT_NAME
    work_path = MAIN_PATH / PROJEECT_NAME
    json_path = MAIN_PATH / "config.json"

    # 读取 config.json 文件
    config = read_json(json_path)

    # 复制项目
    if work_path.exists():
        shutil.rmtree(work_path)

    shutil.copytree(old_project_path, work_path)

    # 更新 Android 文件
    update_android(work_path, config["package"])

    # 更新 iOS 文件
    update_ios(work_path, config["package"], config["team"], config["profile"], config["signing"])

    # 打包
    build(work_path, build_envs)

    # 删除临时文件
    shutil.rmtree(work_path)
    
    summary_path = MAIN_PATH / "DistributionSummary.plist"
    if summary_path.exists():
        summary_path.unlink()

    packaging_log_path = MAIN_PATH / "Packaging.log"
    if packaging_log_path.exists():
        packaging_log_path.unlink()

    print("======> 项目打包完成 ✅✅✅✅✅ \n")

def read_json(path: str):
    with open(path) as file:
        data = json.loads(file.read().strip())
    file.close()

    return data

def update_ios(work_path: str, new_package_name: str, new_team: str, new_profile: str, new_signing: str):
    ios_path = Path(work_path) / "ios"
    plist_path = ios_path / "Runner" / "Info.plist"
    pbxproj_path = ios_path / "Runner.xcodeproj" / "project.pbxproj"

    with open(plist_path, "r+", encoding="utf-8") as file:
        content = file.read()
        content = content.replace(OLD_PACKAGE_NAME, new_package_name)
        file.seek(0)
        file.write(content)
        file.truncate()
    print(f"Info.plist 包名已更新为 {new_package_name}")

    with open(pbxproj_path, "r+", encoding="utf-8") as file:
        content = file.read()
        content = content.replace(OLD_PACKAGE_NAME, new_package_name)
        content = content.replace(OLD_PROFILE, new_profile)
        content = content.replace(OLD_TEAM_ID, new_team)
        content = content.replace(OLD_SIGNING, new_signing)
        
        file.seek(0)
        file.write(content)
        file.truncate()
    print(f"project.pbxproj 已更新为 {new_profile}")

def update_android(work_path: str, new_package_name: str):
    android_path = Path(work_path) / "android/app"
    kotlin_path = android_path / "src/main/kotlin"

    old_package_path = kotlin_path / Path(*OLD_PACKAGE_NAME.split("."))
    new_package_path = kotlin_path / Path(*new_package_name.split("."))

    if old_package_path.exists():
        shutil.move(old_package_path, new_package_path)

    remove_empty_dirs(kotlin_path)

    for item in new_package_path.iterdir():
        if item.suffix == '.kt':
            with item.open('r', encoding='utf-8') as file:
                content = file.read()

            new_content = content.replace(OLD_PACKAGE_NAME, new_package_name)

            with item.open('w', encoding='utf-8') as file:
                file.write(new_content)

            print(f"KT 文件修改成功 --> {item}")

    # 更新 AndroidManifest.xml
    manifest_path = android_path / "src/main/AndroidManifest.xml"
    with open(manifest_path, "r+", encoding="utf-8") as file:
        content = file.read()
        content = content.replace(OLD_PACKAGE_NAME, new_package_name)
        file.seek(0)
        file.write(content)
        file.truncate()
    print(f"AndroidManifest.xml 包名已更新为 {new_package_name}")

    # 更新 build.gradle
    gradle_path = android_path / "build.gradle"
    with open(gradle_path, "r+", encoding="utf-8") as file:
        content = file.read()
        content = content.replace(OLD_PACKAGE_NAME, new_package_name)
        file.seek(0)
        file.write(content)
        file.truncate()
    print("build.gradle 包名已更新")

def remove_empty_dirs(path: Path):
    for child in path.iterdir():
        if child.is_dir():
            remove_empty_dirs(child)

    if not any(path.iterdir()):
        path.rmdir()
        print(f"删除了空文件夹 {path}")

def run_command(command, cwd=None):
    """
    辅助函数，用于运行Shell命令并打印其输出。
    如果命令执行失败，抛出异常并打印错误信息。
    """
    print(f"运行命令: {command}")
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)
    stdout, stderr = process.communicate()
    if process.returncode != 0:
        raise subprocess.CalledProcessError(process.returncode, command, output=stderr)
    print(stdout.decode('utf-8'))

def build(work_path: str, envs: list[str]):
    out_path = MAIN_PATH
    ios_path = Path(work_path) / "ios"
    bild_path = Path(work_path) / "build"
    export_options_path = MAIN_PATH / "ExportOptions.plist"

    run_command("flutter clean", cwd=work_path)
    run_command("flutter pub get", cwd=work_path)
    run_command("pod install", cwd=ios_path)

    for env in envs:
        environment = "--dart-define=ENVIRONMENT=%s" % env

        run_command("flutter build ios -v --release --no-codesign %s" % (environment), cwd=work_path)

        archive_path = bild_path / "ios/archive/Runner.xcarchive"

        # 使用xcodebuild命令创建项目归档和导出IPA文件
        run_command(f"xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release archive -archivePath {archive_path} -destination 'generic/platform=iOS'", cwd=work_path)
        run_command(f"xcodebuild -exportArchive -archivePath {archive_path} -exportOptionsPlist {export_options_path} -exportPath {out_path}", cwd=work_path)

        # 重命名 IPA 文件
        old_ipa_path = out_path / 'cgwallet.ipa'
        new_ipa_path = out_path / f'cgwallet_{env}.ipa'
        old_ipa_path.rename(new_ipa_path)

        run_command("flutter build apk -v --release %s"  % (environment), cwd=work_path)
        old_apk_path =  "app/outputs/flutter-apk/app-release.apk"
        new_apk_path = out_path / f'cgwallet_{env}.apk'

        shutil.copy(bild_path / old_apk_path, out_path / new_apk_path)

if __name__ == "__main__":
    main()