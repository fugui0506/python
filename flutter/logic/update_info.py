from pathlib import Path
from flutter.models.config import BuildConfig
from utils import consol

# 定义需要跳过的文件夹名称
SKIPPED_FOLDERS = {'.git'}

def run(path: Path, config: BuildConfig):
    print()
    consol.log(f'正在更新所有文件里的项目信息: {path.resolve()}')

    # 遍历所有文件和文件夹
    for dart_file in path.rglob('*'):
        # 检查是否属于需要跳过的文件夹
        if any(folder in dart_file.parts for folder in SKIPPED_FOLDERS):
            print(f'跳过文件或文件夹 -> {dart_file.resolve()}')
            continue

        # 如果是文件，则处理
        if dart_file.is_file():
            print(f'正在处理文件 -> {dart_file.resolve()}')
            _common(dart_file, config)

def _common(path: Path, config: BuildConfig):
    try:
        with path.open('r+', encoding='utf-8') as file:
            content = file.read()

            # 替换包名
            if config.target.package and config.project.package and config.target.package != config.project.package:
                content = content.replace(config.project.package, config.target.package)

            # 替换标题
            if config.target.title and config.project.title and config.target.title != config.project.title:
                content = content.replace(config.project.title, config.target.title)

            # 替换 Flutter 名称
            if config.target.flutter_name and config.project.flutter_name and config.target.flutter_name != config.project.flutter_name:
                content = content.replace(config.project.flutter_name, config.target.flutter_name)

            file.seek(0)
            file.write(content)
            file.truncate()

            print(f'文件修改成功 --> {path.resolve()}')

    except UnicodeDecodeError as e:
        print(f"跳过文件 {path.resolve()}，无法解码为 UTF-8: {e}")
    except Exception as e:
        print(f"处理文件 {path.resolve()} 时发生错误: {e}")