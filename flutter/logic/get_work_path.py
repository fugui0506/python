from pathlib import Path
import sys

import inquirer
from utils import consol

def run(works_path: Path):
    """
    获取工作目录，并让用户选择具体的工作目录。
    
    Args:
        works_path (Path): 存放工作目录的路径。
    
    Returns:
        Path: 用户选择的工作目录路径。
    """
    if not works_path.exists():
        consol.error(f"工作目录不存在：{works_path}")
        sys.exit(1)

    # 创建工作目录映射
    work_path_mapping = {
        work.name: work
        for work in works_path.glob('*')
        if work.is_dir()
    }

    if not work_path_mapping:
        consol.error(f"工作目录 {works_path} 下没有找到任何子目录！")
        sys.exit(1)

    # 用户提示信息中的显示名称
    work_path_names = list(work_path_mapping.keys())

    # 提问用户选择工作目录
    questions = [
        inquirer.List(
            'work_path',
            message="请选择工作目录",
            choices=work_path_names,
            default=work_path_names[0]
        )
    ]

    answers = inquirer.prompt(questions)
    selected = answers['work_path']

    # 获取用户选择的工作目录路径
    return work_path_mapping[selected]