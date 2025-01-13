
from pathlib import Path
import sys

import inquirer

project_root = Path(__file__).resolve().parents[1]
sys.path.append(str(project_root))

from utils import consol
from flutter.logic import build

def main():
    print()
    consol.log('开始运行脚本...')

    works_path = Path(__file__).resolve().parent / 'works'

    if not works_path.exists():
        consol.error(f"工作目录不存在：{works_path}")
        return

    work_path_mapping = {}

    # 获取父级目录的所有文件
    for work in works_path.glob('*'):
        if work.is_dir():
            work_path_mapping[work.name] = work
        
    # 用户提示信息中的显示名称
    work_path_names = list(work_path_mapping.keys())
    
    # 提问用户选择打包环境
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
    
    # 获取对应的环境值
    work_path = work_path_mapping.get(selected, work_path_names[0])
    
    # 打印用户选择的环境
    consol.log(f"你选择的工作目录是: {selected}，对应的目录是: {work_path}")
    print()

    print(work_path_mapping)
    build.run(work_path)

if __name__ == "__main__":
    main()