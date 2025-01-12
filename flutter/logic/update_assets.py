from pathlib import Path
import shutil
from utils import consol

def run(project: Path, resource: Path):
    print()
    src_path = resource / 'assets'
    dst_path = project / 'assets'

    consol.log(f'正在更新资源文件 {src_path} -> {dst_path}')

    if dst_path.exists() and src_path.exists():
        consol.log('资源文件夹已存在，正在删除...')
        shutil.rmtree(dst_path)
        shutil.copytree(src_path, dst_path)
    
    consol.succful('资源文件夹更新成功...')