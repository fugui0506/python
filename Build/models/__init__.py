from pathlib import Path
import sys

# 添加 python 根目录到 sys.path
project_root = Path(__file__).resolve().parents[2]  # 获取 python 根目录
sys.path.append(str(project_root))
