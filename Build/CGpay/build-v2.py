
from pathlib import Path
import shutil
import sys

# 添加 python 根目录到 sys.path
project_root = Path(__file__).resolve().parents[2]
sys.path.append(str(project_root))

from utils import consol, json, cmd
from Build.logic import get_build_envs, set_config, update_info, update_yaml, update_assets, update_android, update_ios, copy_project, update_plist
from Build.models.config import BuildConfig

BUILD_ENVS: list[str] = ['test', 'rel', 'pre', 'grey']

def main():
    consol.log('开始运行脚本...')

    # 工作目录
    works_path = Path(__file__).resolve().parent

    # 资源目录
    resource_path = works_path / "resource"

    # 需要打包的环境
    build_envs = get_build_envs.run(BUILD_ENVS)
    consol.log(f"需要打包的环境: {build_envs}")

    # json 配置文件的目录必须存在
    json_path = works_path / "config.json"
    if json_path not in works_path.iterdir():
        consol.error('没有找到config.json配置文件...')
        return

    # plist 文件的目录必须存在
    export_options_path = works_path / "ExportOptions.plist"
    if export_options_path not in works_path.iterdir():
        consol.error('没有找到ExportOptions.plist导出配置文件...')
        return
    
    # 读取 json 配置文件
    config_file = json.read(json_path)

    # json 文件格解析成 BuildConfig
    config = BuildConfig.from_json(config_file)

    print()
    consol.succful(f"project: {json.dumps(config.project.to_json())}")
    consol.succful(f"target: {json.dumps(config.target.to_json())}")

    # 删除旧的项目目录
    if config.target.name != "":
        project_path = works_path / str(config.target.name)
    else:
        project_path = works_path / 'project'
        config.target.name = project_path.name

    if project_path.exists():
        shutil.rmtree(project_path)
        print()
        consol.succful(f"删除文件夹成功: {project_path}")

    # 更改签名文件
    update_plist.run(works_path, config)

    # 复制项目
    copy_project.run(Path(config.project.path), project_path)

    cmd.run("flutter clean", cwd=project_path)

    # 设置配置参数
    set_config.run(project_path, config)

    # 更新所有文件的项目信息
    update_info.run(project_path, config)

    # 更新 yaml 配置文件    
    update_yaml.run(project_path, config)

    # 更新 assets 文件
    update_assets.run(project_path, resource_path)

    # 更新 android 文件
    update_android.run(project_path, config, resource_path)

    # 更新 ios 文件
    update_ios.run(project_path, config, resource_path)

    # 打包
    print()
    consol.log('正在打包...')
    print()

    ios_path = project_path / "ios"
    build_path = project_path / "build"

    cmd.run("flutter pub get", cwd=project_path)
    cmd.run("pod install", cwd=ios_path)

    env_index = 0
    for env in build_envs:
        env_index += 1
        print()
        consol.log(f"正在处理 {env_index} / {len(build_envs)} 个环境 -> {env}")
        print()

        environment = "--dart-define=ENVIRONMENT=%s" % env

        cmd.run("flutter build ios --release --no-codesign %s" % (environment), cwd=project_path)

        archive_path = build_path / "ios/archive/Runner.xcarchive"

        # 使用xcodebuild命令创建项目归档和导出IPA文件
        cmd.run(f"xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release archive -archivePath {archive_path} -destination 'generic/platform=iOS'", cwd=project_path)
        cmd.run(f"xcodebuild -exportArchive -archivePath {archive_path} -exportOptionsPlist {export_options_path} -exportPath {works_path}", cwd=project_path)

        app_name = config.target.title
        if app_name == "":
            app_name = config.project.title

        app_version = config.target.version
        if app_version == "":
            app_version = config.project.version

        ipa_old_name = config.target.flutter_name
        if ipa_old_name == "":
            ipa_old_name = config.project.flutter_name

        # 重命名 IPA 文件
        old_ipa_path = works_path / f'{ipa_old_name}.ipa'
        new_ipa_path = works_path / f'{app_name}_{env}_flutter_{app_version}.ipa'
        old_ipa_path.rename(new_ipa_path)
        consol.succful(f"✅ IOS {env} 已完成打包")

        cmd.run("flutter build apk --release %s"  % (environment), cwd=project_path)
        old_apk_path =  "app/outputs/flutter-apk/app-release.apk"
        new_apk_path = works_path / f'{app_name}_{env}_flutter_{app_version}.apk'

        shutil.copy(build_path / old_apk_path, works_path / new_apk_path)
        consol.succful(f"Android 第 {env_index} 个环境 -> {env} 已完成")


        consol.succful(f"✅ Android {env} 已完成打包")

    summary_path = works_path / "DistributionSummary.plist"
    if summary_path.exists():
        summary_path.unlink()

    packaging_log_path = works_path / "Packaging.log"
    if packaging_log_path.exists():
        packaging_log_path.unlink()

    shutil.rmtree(project_path)

    print()
    consol.succful('✅✅✅✅✅ 任务完成...')

if __name__ == "__main__":
    main()