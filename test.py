from enum import Enum
import os
import subprocess
import shutil
from datetime import datetime

# 设置 Flutter 项目路径
PROJECT_DIR = os.path.expanduser("~/Documents/Projects/wallet-flutter-app")
# 项目的 Build 目录
BUILD_DIR = os.path.join(PROJECT_DIR, "build")
# 存放包的目录
OUTPUT_DIR = os.path.expanduser("~/Documents/Outputs/wallet-flutter-app")
# ios 的路径
IOS_DIR = os.path.join(PROJECT_DIR, "ios")
# ios 配置文件的路径
ARCHIVE_PATH = os.path.join(BUILD_DIR, "ios/archive/Runner.xcarchive")
# ios 在当前脚本目录下查找 ExportOptions.plist
EXPORT_OPTIONS_PLIST = os.path.join(os.path.dirname(__file__), "ExportOptions.plist")
# 构建时间
BUILD_TIME = datetime.now().strftime("%Y%m%d_%H%M%S")

# 定义一个枚举类
class ENVIRONMENT(Enum):
    test = '--dart-define=ENVIRONMENT=test'
    pre = '--dart-define=ENVIRONMENT=pre'
    rel = '--dart-define=ENVIRONMENT=rel'

class NAME(Enum):
    test = 'test'
    pre = 'pre'
    rel = 'rel'

def run_command(command, cwd=None):
    """
    辅助函数，用于运行Shell命令并打印其输出。
    如果命令执行失败，抛出异常并打印错误信息。
    """
    print(f"运行命令: {command}")
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)
    stdout, stderr = process.communicate()
    if process.returncode != 0:
        raise subprocess.CalledProcessError(process.returncode, command, output=stderr)
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

def install_cocoapods():
    """
    安装iOS项目的CocoaPods依赖。
    """
    run_command("pod install", cwd=IOS_DIR)

def build_flutter_ipa(environment: ENVIRONMENT):
    """
    构建iOS版本的Flutter项目，使用发布模式并禁用代码签名。
    """
    run_command("flutter build ios -v --release --no-codesign %s" % (environment.value), cwd=PROJECT_DIR)

def create_xcode_archive():
    """
    创建Xcode归档文件并使用指定的ExportOptions.plist导出IPA文件。
    """
    # 检查ExportOptions.plist文件是否存在
    if not os.path.exists(EXPORT_OPTIONS_PLIST):
        raise FileNotFoundError(f"ExportOptions.plist文件未找到: {EXPORT_OPTIONS_PLIST}")

    # 使用xcodebuild命令创建项目归档和导出IPA文件
    run_command(f"xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release archive -archivePath {ARCHIVE_PATH} -destination 'generic/platform=iOS'", cwd=PROJECT_DIR)
    run_command(f"xcodebuild -exportArchive -archivePath {ARCHIVE_PATH} -exportOptionsPlist {EXPORT_OPTIONS_PLIST} -exportPath {OUTPUT_DIR}", cwd=PROJECT_DIR)

    # 重命名IPA文件
    old_ipa_path = os.path.join(OUTPUT_DIR, 'cgwallet.ipa')
    new_ipa_path = os.path.join(OUTPUT_DIR, 'cgwallet_%s.ipa' % (NAME.test.value))
    os.rename(old_ipa_path, new_ipa_path)

def build_flutter_apk(environment: ENVIRONMENT):
    """
    构建安卓版本的Flutter项目，使用发布模式。
    """
    run_command("flutter build apk -v --release %s"  % (environment.value), cwd=PROJECT_DIR)

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
        raise FileNotFoundError(f"找不到生成的APK文件: {apk_file}")
    
    # 重命名IPA文件
    old_apk_path = os.path.join(OUTPUT_DIR, 'app-release.apk')
    new_apk_path = os.path.join(OUTPUT_DIR, 'cgwallet_%s.apk' % (NAME.test.value))
    os.rename(old_apk_path, new_apk_path)

def main():
    """
    主函数，按顺序执行清理、获取依赖、安装CocoaPods依赖、构建和归档步骤。
    """
    try:
        clean_flutter_project()
        get_flutter_dependencies()

        install_cocoapods()

        build_flutter_ipa(ENVIRONMENT.test)
        create_xcode_archive()
        print("成功创建IPA%s文件。" % (ENVIRONMENT.test.value))

        build_flutter_apk(ENVIRONMENT.test)
        copy_apk_to_output()
        print("成功创建并复制APK%s文件。" % (ENVIRONMENT.test.value))
    except Exception as e:
        print(f"错误: {e}")

if __name__ == "__main__":
    main()