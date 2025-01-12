
from pathlib import Path
import sys

# 添加 python 根目录到 sys.path
project_root = Path(__file__).resolve().parents[2]
sys.path.append(str(project_root))

from utils import consol
from flutter.logic import build

def main():
    print()
    consol.log('开始运行脚本...')
    works_path = Path(__file__).resolve().parent
    build.run(works_path)

if __name__ == "__main__":
    main()