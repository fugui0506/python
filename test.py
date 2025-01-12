import inquirer

def main():
    # 选择打包类型
    questions = [
        inquirer.List(
            'build_type',
            message="请选择打包类型",
            choices=['flutter', 'hot', 'patch'],
            default='flutter'
        ),
        inquirer.List(
            'build_env',
            message="请选择打包环境",
            choices=['prod', 'pre', 'grey'],
            default='prod'
        )
    ]

    answers = inquirer.prompt(questions)
    
    build_type = answers['build_type']
    build_env = answers['build_env']
    
    print(f"你选择的打包类型是: {build_type}")
    print(f"你选择的打包环境是: {build_env}")

if __name__ == "__main__":
    main()