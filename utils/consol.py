import os
import utils.os as path

COLOR_FORMAT = '\033[0;35;40m==\033[0;35;40m>\033[0;%d;40m %s\033[0m'
MAIN_PATH = os.path.dirname(os.path.abspath(__file__))
LOG_PATH = os.path.join(os.path.dirname(MAIN_PATH), '日志.log')

def error(message: str):
    '''
    - 系统输出信息: 错误信息
    - 日志会单独用一个文本记录
    '''
    print(COLOR_FORMAT % (31, message))
    path.write(LOG_PATH, message)


def log(message: str):
    '''
    - 系统输出信息: 普通输出日志
    - 日志会单独用一个文本记录
    '''
    print(COLOR_FORMAT % (33, message))
    path.write(LOG_PATH, message)



def succful(message: str):
    '''
    - 系统输出信息: 成功信息的输出
    - 日志会单独用一个文本记录
    '''
    print(COLOR_FORMAT % (32, message))
    path.write(LOG_PATH, message)

