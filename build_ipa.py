import os
import subprocess

# 设置Flutter项目路径
PROJECT_DIR = os.path.expanduser("~/Documents/Projects/wallet-flutter-app")
IOS_DIR = os.path.join(PROJECT_DIR, "ios")
BUILD_DIR = os.path.join(PROJECT_DIR, "build")
ARCHIVE_PATH = os.path.join(BUILD_DIR, "ios/archive/Runner.xcarchive")
# 在当前脚本目录下查找 ExportOptions.plist
EXPORT_OPTIONS_PLIST = os.path.join(os.path.dirname(__file__), "ExportOptions.plist")
EXPORT_OUTPUT_PATH = os.path.join("~/Documents", "Outputs/wallet-flutter-app")

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

def install_cocoapods_dependencies():
    """
    安装iOS项目的CocoaPods依赖。
    """
    run_command("pod install", cwd=IOS_DIR)

def build_flutter_project():
    """
    构建iOS版本的Flutter项目，使用发布模式并禁用代码签名。
    """
    run_command("flutter build ios --release --no-codesign", cwd=PROJECT_DIR)

def create_xcode_archive():
    """
    创建Xcode归档文件并使用指定的ExportOptions.plist导出IPA文件。
    """
    # 检查ExportOptions.plist文件是否存在
    if not os.path.exists(EXPORT_OPTIONS_PLIST):
        raise Exception(f"ExportOptions.plist文件未找到: {EXPORT_OPTIONS_PLIST}")

    # 使用xcodebuild命令创建项目归档和导出IPA文件
    run_command(f"xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release archive -archivePath {ARCHIVE_PATH} -destination 'generic/platform=iOS'", cwd=PROJECT_DIR)
    run_command(f"xcodebuild -exportArchive -archivePath {ARCHIVE_PATH} -exportOptionsPlist {EXPORT_OPTIONS_PLIST} -exportPath {EXPORT_OUTPUT_PATH}", cwd=PROJECT_DIR)

def main():
    """
    主函数，按顺序执行清理、获取依赖、安装CocoaPods依赖、构建和归档步骤。
    """
    try:
        clean_flutter_project()
        get_flutter_dependencies()
        install_cocoapods_dependencies()
        build_flutter_project()
        create_xcode_archive()
        print("成功创建IPA文件。")
    except Exception as e:
        print(f"错误: {e}")

if __name__ == "__main__":
    main()
