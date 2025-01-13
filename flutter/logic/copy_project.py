import os
import shutil
from pathlib import Path

from utils import consol

def run(src_path: Path, dst_path: Path):
    """
    自动查找 .gitignore 并根据规则从源目录复制到目标目录。没有 .gitignore 时直接复制所有内容。
    
    :param src: 源目录路径。
    :param dst: 目标目录路径。
    """

    print()
    consol.log(f'正在复制文件: {src_path} => {dst_path}')
    
    # 查找 .gitignore 文件
    gitignore_path = src_path / ".gitignore"
    if gitignore_path.exists():
        # 如果 .gitignore 存在，解析规则
        consol.log(f"检测到 .gitignore 文件，按规则过滤：{gitignore_path}")
        ignore_patterns = _parse_gitignore(gitignore_path)
    else:
        # 如果 .gitignore 不存在，跳过过滤
        consol.log("未检测到 .gitignore 文件，将复制所有文件和文件夹。")
        ignore_patterns = None

    # 遍历源目录并复制
    for root, dirs, files in os.walk(src_path):
        root_path = Path(root)

        # 检查并跳过忽略的文件夹
        if ignore_patterns:
            dirs[:] = [d for d in dirs if not _should_ignore(root_path / d, ignore_patterns, src_path)]

        # 复制文件
        for file in files:
            file_path = root_path / file
            if not ignore_patterns or not _should_ignore(file_path, ignore_patterns, src_path):
                # 确定目标路径
                relative_path = file_path.relative_to(src_path)
                target_path = dst_path / relative_path

                # 创建目标文件夹
                target_path.parent.mkdir(parents=True, exist_ok=True)

                # 复制文件
                shutil.copy2(file_path, target_path)
                print(f"已复制文件: {file_path} -> {target_path}")

    consol.succful(f"已完成从 {src_path} 到 {dst_path} 的复制")

def _parse_gitignore(file_path: Path):
    """
    解析 .gitignore 文件，返回需要忽略的模式列表。
    
    :param file_path: .gitignore 文件路径。
    :return: 忽略的模式列表。
    """
    ignore_patterns = []
    with file_path.open('r') as file:
        for line in file:
            # 去除空格和换行符
            line = line.strip()
            
            # 跳过空行和注释
            if not line or line.startswith('#'):
                continue
            
            # 标准化路径分隔符
            ignore_patterns.append(line)
    return ignore_patterns

def _should_ignore(path: Path, ignore_patterns: list, base_path: Path):
    """
    检查路径是否需要忽略。
    
    :param path: 当前文件或文件夹路径。
    :param ignore_patterns: 忽略的模式列表。
    :param base_path: 根目录路径，用于匹配相对路径。
    :return: 如果需要忽略则返回 True，否则返回 False。
    """
    relative_path = path.relative_to(base_path)
    for pattern in ignore_patterns:
        if relative_path.match(pattern) or str(relative_path).startswith(pattern):
            return True
    return False