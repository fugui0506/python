from utils import consol
def run(envs: list[str]) -> list[str]:
    print()
    input_str = input("请输入打包环境,多个环境用逗号隔开(如: test, rel):  ")

    input_str = input_str.replace(' ', '')
    build_envs = input_str.split(',')

    index = 0
    while index < len(build_envs):
        if build_envs[index] not in envs:
            build_envs.remove(build_envs[index])
        else:
            index += 1
    
    build_envs = list(set(build_envs))

    if (len(build_envs) == 0):
        build_envs = ['test']

    print()
    consol.log("开始打包 %s" % (build_envs))

    return build_envs