
from pathlib import Path
import shutil
import sys

# 添加 python 根目录到 sys.path
project_root = Path(__file__).resolve().parents[2]
sys.path.append(str(project_root))

from utils import consol, json, cmd
from Build.logic import get_build_envs, set_config, update_info, update_yaml, update_assets, update_android, update_ios, copy_project, update_plist
from Build.models.config import BuildConfig

BUILD_ENVS: list[str] = ['test', 'rel', 'pre', 'grey']

def main():
    consol.log('开始运行脚本...')

    

if __name__ == "__main__":
    main()