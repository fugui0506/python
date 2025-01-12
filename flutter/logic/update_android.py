import shutil
from pathlib import Path

from flutter.models import config
from utils import consol, os


def run(path: Path, config: config.BuildConfig, resource: Path):
    """更新 Android 文件"""

    if config.target.package == "":
        return

    print()
    
    android_path = path / "android/app"
    kotlin_path = android_path / "src/main/kotlin"
    resource_path = resource / "android"

    consol.log(f'正在更新 Android 文件 -> {android_path}')

    # 检查目标路径是否已经存在，避免移动到子目录中
    _move_package(kotlin_path, config)

    if resource_path.exists():
        launch_image = "launch_image.png"
        launch_image_path = android_path / "src/main/res/mipmap"
        launch_image_path.mkdir(parents=True, exist_ok=True)
        try:
            shutil.copy(resource_path / "mipmap" / launch_image, launch_image_path / launch_image)
            consol.succful(f"资源文件 {launch_image} 已复制到 {launch_image_path}")
        except FileNotFoundError as e:
            consol.error(f"找不到资源文件 {launch_image}，跳过复制。错误: {e}")
        except Exception as e:
            consol.error(f"复制资源文件 {launch_image} 时出错: {e}")

        ic_launcher = "ic_launcher.png"

        mipmap_paths = {
            "hdpi": android_path / "src/main/res/mipmap-hdpi",
            "ldpi": android_path / "src/main/res/mipmap-ldpi",
            "mdpi": android_path / "src/main/res/mipmap-mdpi",
            "xhdpi": android_path / "src/main/res/mipmap-xhdpi",
            "xxhdpi": android_path / "src/main/res/mipmap-xxhdpi",
            "xxxhdpi": android_path / "src/main/res/mipmap-xxxhdpi"
        }

        # 创建目录并复制资源文件
        for density, path in mipmap_paths.items():
            path.mkdir(parents=True, exist_ok=True)
            try:
                shutil.copy(resource_path / f"mipmap-{density}" / ic_launcher, path / ic_launcher)
                consol.succful(f"资源文件 {ic_launcher} 已复制到 {path}")
            except FileNotFoundError as e:
                consol.error(f"找不到资源文件 {ic_launcher} 在 {density}，跳过复制。错误: {e}")
            except Exception as e:
                consol.error(f"复制资源文件 {ic_launcher} 到 {path} 时出错: {e}")

        consol.succful("✅ Android 资源文件已更新 ....")
    else:
        consol.error(f"资源文件路径 {resource_path} 不存在，跳过资源文件更新。")

def _move_package(path: Path, config: config.BuildConfig):
    old_package_path = path / Path(*config.project.package.split("."))
    new_package_path = path / Path(*config.target.package.split("."))

    # 检查目标路径是否已经存在，避免移动到子目录中
    try:
        if old_package_path.exists() and not new_package_path.exists():
            consol.log(f"正在移动包路径: {old_package_path} -> {new_package_path}")
            shutil.move(str(old_package_path), str(new_package_path))
        elif old_package_path.exists():
            consol.log(f"目标路径 {new_package_path} 已存在，跳过移动。")
        else:
            consol.log(f"源路径 {old_package_path} 不存在，跳过移动。")
    except Exception as e:
        consol.error(f"移动包路径时出错: {e}")

    os.remove_dirs(path)