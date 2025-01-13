from pathlib import Path
import shutil
from utils import consol, json, cmd
from flutter.logic import (
    get_build_envs,
    set_config,
    update_info,
    update_yaml,
    update_assets,
    update_android,
    update_ios,
    copy_project,
    update_plist,
    get_build_type
)
from flutter.models.config import BuildConfig
from flutter.models.build_type import BuildType

FLUTTER_VERSION: str = '3.27.1'

def _validate_paths(works_path: Path) -> tuple[Path, Path]:
    """验证配置文件路径是否存在"""
    json_path = works_path / "config.json"
    export_options_path = works_path / "ExportOptions.plist"

    if not json_path.exists():
        raise FileNotFoundError('没有找到 config.json 配置文件')
    if not export_options_path.exists():
        raise FileNotFoundError('没有找到 ExportOptions.plist 配置文件')

    return json_path, export_options_path


def _prepare_project(works_path: Path, config: BuildConfig) -> Path:
    """删除旧项目目录并准备新项目"""
    project_path = works_path / (config.target.name or "project")
    if project_path.exists():
        shutil.rmtree(project_path)
        consol.succful(f"删除旧项目目录: {project_path}")
    copy_project.run(Path(config.project.path), project_path)
    cmd.run("flutter clean", cwd=project_path)
    return project_path


def _build_ios(project_path: Path, works_path: Path, config: BuildConfig, environment: str, build_type: BuildType):
    """构建 iOS 平台"""
    cmd.run("flutter pub get", cwd=project_path)
    cmd.run("pod install", cwd=project_path / "ios")

    if build_type == BuildType.FLUTTER:
        cmd.run(f"flutter build ios --release --no-codesign {environment}", cwd=project_path)
    elif build_type == BuildType.HOT:
        cmd.run(f"yes '' | shorebird release ios --no-codesign {environment} --flutter-version={FLUTTER_VERSION}", cwd=project_path)
    elif build_type == BuildType.UPDATE:
        cmd.run(f"yes '' | shorebird patch ios --no-codesign {environment} --verbose", cwd=project_path)

    if build_type in [BuildType.FLUTTER, BuildType.HOT]:
        archive_path = project_path / "build/ios/archive/Runner.xcarchive"
        cmd.run(f"xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release archive -archivePath {archive_path} -destination 'generic/platform=iOS'", cwd=project_path)
        cmd.run(f"xcodebuild -exportArchive -archivePath {archive_path} -exportOptionsPlist {works_path / 'ExportOptions.plist'} -exportPath {works_path}", cwd=project_path)
        _rename_output_file(works_path, project_path, config, "ipa", environment.split('=')[-1], build_type)


def _build_android(project_path: Path, works_path: Path, config: BuildConfig, environment: str, build_type: BuildType):
    """构建 Android 平台"""
    if build_type == BuildType.FLUTTER:
        cmd.run(f"flutter build apk --release {environment}", cwd=project_path)
    elif build_type == BuildType.HOT:
        cmd.run(f"yes '' | shorebird release android --artifact apk {environment} --flutter-version={FLUTTER_VERSION}", cwd=project_path)
    elif build_type == BuildType.UPDATE:
        cmd.run(f"yes '' | shorebird patch android {environment} --verbose", cwd=project_path)

    if build_type in [BuildType.FLUTTER, BuildType.HOT]:
        _rename_output_file(works_path, project_path, config, "apk", environment.split('=')[-1], build_type)


def _rename_output_file(works_path: Path, project_path: Path, config: BuildConfig, extension: str, environment: str, build_type: BuildType):
    """重命名输出文件"""
    app_name = config.target.title or config.project.title
    app_version = config.target.version or config.project.version
    flutter_name = config.target.flutter_name or config.project.flutter_name
    build_name = build_name = build_type.name.lower()

    old_file = works_path / f"{flutter_name}.{extension}"
    new_file = works_path / f"{app_name}_{environment}_{build_name}_{app_version}.{extension}"

    if old_file.exists():
        old_file.rename(new_file)
    else:
        old_file = project_path / "build/app/outputs/flutter-apk/app-release.apk"
        shutil.copy(old_file, new_file)

    consol.succful(f"✅ {extension.upper()} 文件重命名完成: {new_file}")
    


def _clean_up(works_path: Path, project_path: Path):
    """清理临时文件和目录"""
    for file_name in ["DistributionSummary.plist", "Packaging.log"]:
        file_path = works_path / file_name
        if file_path.exists():
            file_path.unlink()
            
    if project_path.exists():
        shutil.rmtree(project_path)
        consol.succful(f"已清理项目目录: {project_path}")


def run(works_path: Path):
    """主函数"""
    try:
        # 验证文件路径
        json_path, _ = _validate_paths(works_path)

        # 加载配置
        config = BuildConfig.from_json(json.read(json_path))
        consol.succful(f"配置加载完成: {config.project.to_json()}")

        # 准备项目
        project_path = _prepare_project(works_path, config)

        # 更新配置和资源
        update_plist.run(works_path, config)
        set_config.run(project_path, config)
        update_info.run(project_path, config)
        update_yaml.run(project_path, config)
        update_assets.run(project_path, works_path / "resource")
        update_android.run(project_path, config, works_path / "resource")
        update_ios.run(project_path, config, works_path / "resource")

        # 构建所有环境
        build_env = get_build_envs.run()
        build_type = get_build_type.run()

        consol.log(f"开始构建环境: {build_env}")
        _build_ios(project_path, works_path, config, f"--dart-define=ENVIRONMENT={build_env}", build_type)
        _build_android(project_path, works_path, config, f"--dart-define=ENVIRONMENT={build_env}", build_type)

        consol.succful("✅ 全部构建完成!")
    except Exception as e:
        consol.error(f"发生错误: {e}")
        raise
    finally:
        _clean_up(works_path, project_path)