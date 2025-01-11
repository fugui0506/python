from pathlib import Path
from Build.models.config import BuildConfig
from utils import consol

def run(path: Path, config: BuildConfig):
    print()
    consol.log(f'正在更新所有文件里的项目信息: {path.resolve()}')

    for dart_file in path.rglob('*'):
        consol.log(f'正在处理文件 -> {dart_file.resolve()}')

        if dart_file.is_file():
            _common(dart_file, config)

def _common(path: Path, config: BuildConfig):
    try:
        with path.open('r+', encoding='utf-8') as file:
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

            consol.succful(f'文件修改成功 --> {path.resolve()}')
    
    except UnicodeDecodeError as e:
        consol.error(f"跳过文件 {path.resolve()}，无法解码为 UTF-8: {e}")
    except Exception as e:
        consol.error(f"处理文件 {path.resolve()} 时发生错误: {e}")