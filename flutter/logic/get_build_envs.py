import inquirer
from utils import consol

def run() -> str:
    # 定义环境选项的名称与对应的值
    build_env_mapping = {
        '测试环境': 'test',
        '正式环境': 'rel',
        '预发环境': 'pre',
        '灰度环境': 'grey'
    }

    # 用户提示信息中的显示名称
    build_env_display_names = list(build_env_mapping.keys())
    
    # 提问用户选择打包环境
    questions = [
        inquirer.List(
            'build_env',
            message="请选择打包环境",
            choices=build_env_display_names,
            default=build_env_display_names[0]
        )
    ]

    answers = inquirer.prompt(questions)
    selected_build_env_name = answers['build_env']
    
    # 获取对应的环境值
    selected_build_env = build_env_mapping.get(selected_build_env_name, 'test')
    
    # 打印用户选择的环境
    consol.log(f"你选择的打包环境是: {selected_build_env_name}，对应的环境值是: {selected_build_env}")
    print()
    
    return selected_build_env