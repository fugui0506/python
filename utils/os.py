import os
from pathlib import Path
import shutil
from utils import  consol
from tqdm import tqdm

def write(path: str, content: str, type: str = 'a+'):
    '''
    ## 文件的写入方法
    ### type:
    + 'a' 在文件的末尾追加写入
    + 'r' 读取模式( 默认值 )
    + 'w' 写入模式
    + 'x' 独占写入模式
    + 'a' 附加模式
    + 'b' 二进制模式( 与其他模式结合使用 )
    + 't' 文本模式( 默认值, 与其他模式结合使用 )
    + '+' 读写模式( 与其他模式结合使用 )
    '''
    with open(path, type, newline='\n', encoding='utf-8') as f:
        f.write('%s\n' % (content))
    f.close()

def copy(src_path: Path, dst_path: Path):
    # 复制项目
    consol.log(f"正在复制文件夹 {src_path} -> {dst_path}")

    files = list(Path(src_path).rglob('*'))

    with tqdm(total=len(files), desc="Copying files") as pbar:
        for item in files:
            target_path = dst_path / item.relative_to(src_path)

            # 确保目标路径的父目录存在
            if not target_path.parent.exists():
                target_path.parent.mkdir(parents=True, exist_ok=True)

            if item.is_dir():
                target_path.mkdir(parents=True, exist_ok=True)
            else:
                shutil.copy2(item, target_path)
            pbar.update(1)

    # shutil.copytree(Path(config.project.path), project_path)
    consol.succful(f"文件夹复制成功: {dst_path}")

def remove_dirs(path: Path):
    for child in path.iterdir():
        if child.is_dir():
            remove_dirs(child)

    if not any(path.iterdir()):
        path.rmdir()
        consol.succful(f"删除了空文件夹 {path}")
