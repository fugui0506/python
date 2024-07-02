import os
import subprocess
import shutil

# 设置Flutter项目路径
PROJECT_DIR = os.path.expanduser("~/Documents/Projects/wallet-flutter-app")
BUILD_DIR = os.path.join(PROJECT_DIR, "build")
OUTPUT_DIR = os.path.expanduser("~/Documents/Outputs/wallet-flutter-app")

def run_command(command, cwd=None):
    """
    辅助函数，用于运行Shell命令并打印其输出。
    如果命令执行失败，抛出异常并打印错误信息。
    """
    print(f"运行命令: {command}")
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)
    stdout, stderr = process.communicate()
    if process.returncode != 0:
        raise Exception(f"命令执行失败，错误信息: {stderr.decode('utf-8')}")
    print(stdout.decode('utf-8'))

def clean_flutter_project():
    """
    清理Flutter项目。
    """
    run_command("flutter clean", cwd=PROJECT_DIR)

def get_flutter_dependencies():
    """
    获取Flutter项目的依赖。
    """
    run_command("flutter pub get", cwd=PROJECT_DIR)

def build_flutter_apk():
    """
    构建安卓版本的Flutter项目，使用发布模式。
    """
    run_command("flutter build apk --release", cwd=PROJECT_DIR)

def copy_apk_to_output():
    """
    将生成的APK复制到指定的输出目录。
    """
    # 确保输出目录存在
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    # 构建APK的目录
    apk_dir = os.path.join(BUILD_DIR, "app", "outputs", "flutter-apk")
    apk_file = os.path.join(apk_dir, "app-release.apk")
    
    # 检查APK文件是否存在
    if os.path.exists(apk_file):

        # 复制到输出目录
        shutil.copy(apk_file, OUTPUT_DIR)
        print(f"成功复制APK文件到 {OUTPUT_DIR}")
    else:
        raise Exception(f"找不到生成的APK文件: {apk_file}")

def main():
    """
    主函数，按顺序执行清理、获取依赖、构建APK和复制到输出目录步骤。
    """
    try:
        clean_flutter_project()
        get_flutter_dependencies()
        build_flutter_apk()
        copy_apk_to_output()
        print("成功创建并复制APK文件。")
    except Exception as e:
        print(f"错误: {e}")

if __name__ == "__main__":
    main()
