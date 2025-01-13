from asyncio import subprocess
import subprocess
from utils import consol

def run(command, cwd=None):
    """
    辅助函数，用于运行Shell命令并打印其输出。
    如果命令执行失败，抛出异常并打印错误信息。
    """
    consol.log("-" * 120)
    consol.log("运行命令: %s" % command)
    consol.log("命令路径: %s" % cwd)
    print()

    # 执行命令并获取stdout和stderr
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)
    
    # 捕获输出并逐行打印
    stdout_lines = []
    stderr_lines = []
    
    # 逐行读取并打印stdout和stderr的内容
    for stdout_line in iter(process.stdout.readline, b''):
        decoded_line = stdout_line.decode('utf-8')
        stdout_lines.append(decoded_line)
        # 实时打印标准输出
        print(decoded_line, end='')

    for stderr_line in iter(process.stderr.readline, b''):
        decoded_line = stderr_line.decode('utf-8')
        stderr_lines.append(decoded_line)
        # 实时打印错误输出
        print(decoded_line, end='')

    process.stdout.close()
    process.stderr.close()
    process.wait()

    if process.returncode != 0:
        raise subprocess.CalledProcessError(process.returncode, command, output="".join(stderr_lines))

    print()
    consol.succful("命令运行完成: %s" % command)
    consol.log("-" * 120)