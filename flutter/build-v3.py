from pathlib import Path
import sys

# 添加项目根路径到 sys.path
project_root = Path(__file__).resolve().parents[1]
sys.path.append(str(project_root))

from utils import consol
from flutter.logic import build, get_work_path

def main():
    print()
    consol.log('开始运行脚本...')

    # 定义工作目录路径
    works_path = Path(__file__).resolve().parent / 'works'

    # 获取用户选择的工作目录
    work_path = get_work_path.run(works_path)

    # 打印用户选择工作目录
    consol.log(f"你选择的工作目录是: {work_path.name}，对应的路径是: {work_path}")
    print()

    # 调用 build 脚本
    build.run(work_path)

if __name__ == "__main__":
    main()