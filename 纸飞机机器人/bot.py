import requests
import time
import signal
import sys

# Telegram Bot 信息
BOT_TOKEN = "7793062238:AAF2vDcIQloRmUqlBt6yKtBLCg8lkoJvBeI"  # 替换为您的 Bot Token
CHAT_IDS = [
    -1002452023162,
    6911246868,
]

# 上次处理的消息 ID
last_update_id = None

# 处理更新消息的函数
def get_updates(offset=None):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/getUpdates"
    params = {"offset": offset}
    try:
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.Timeout:
        print("请求超时，请检查网络连接。")
        return {}
    except requests.exceptions.HTTPError as e:
        print(f"请求失败: {e}")
        return {}
    except Exception as e:
        print(f"发生错误: {e}")
        return {}

# 发送消息的函数
def send_message(chat_id, message, reply_text=None):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": chat_id,
        "text": message,
        "reply_to_message_id": reply_text
    }
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        print(f"给 {chat_id} 的消息发送成功 -> {message}")
    except requests.exceptions.HTTPError as e:
        print(f"发送消息失败: {e}")
    except Exception as e:
        print(f"发生错误: {e}")

# 处理收到的消息
def handle_updates():
    global last_update_id  # 使用全局变量来跟踪最后处理的消息 ID
    updates = get_updates(offset=last_update_id)
    
    # 遍历所有的更新
    for update in updates.get('result', []):
        if 'message' not in update:
            continue
        
        chat_id = update['message']['chat']['id']
        text = update['message'].get('text', '')
        update_id = update['update_id']
        
        # 获取聊天的类型：如果是用户，打印 username 或姓名；如果是群组，打印 title
        if 'username' in update['message']['chat']:
            username = update['message']['chat']['username']
            first_name = update['message']['from'].get('first_name', '')
            last_name = update['message']['from'].get('last_name', '')
            full_name = f"{first_name} {last_name}".strip()
            print(f"收到消息 -> 用户: {username} ({full_name}), Chat ID: {chat_id}, 消息内容: {text}")
        elif 'title' in update['message']['chat']:
            group_name = update['message']['chat']['title']
            print(f"收到消息 -> 群组: {group_name}, Chat ID: {chat_id}, 消息内容: {text}")

        # 判断 text 的类型
        if isinstance(text, str) and "执行 " in text:
            commond_text = text.split("执行 ")[1]
            # 如果消息是 /1，回复一个字符串，并且带上原消息
            if commond_text == "登录" or commond_text == "登陆":
                send_message(chat_id, f"正在执行【{commond_text}】命令...", update['message']['message_id'])
                send_message(chat_id, f"你发送的消息是: {text}", update['message']['message_id'])

                
            else:
                print("没有找到 【%s】相关的命令... " % (commond_text))
                send_message(chat_id, f"我无法执行【{commond_text}】的命令,该命令不存在...", update['message']['message_id'])

        # 更新 last_update_id，以确保下次从此之后的消息开始处理
        last_update_id = update_id + 1

# 退出时发送消息的函数
def exit_handler(signum, frame):
    print("程序终止，发送退出消息到群组...")
    for chat_id in CHAT_IDS:
        send_message(chat_id, "Bot 已关闭")
    sys.exit(0)

if __name__ == "__main__":
    # 设置退出时的信号处理
    signal.signal(signal.SIGINT, exit_handler)

    for chat_id in CHAT_IDS:
        send_message(chat_id, "Bot 已启动")


    try:
        while True:
            handle_updates()
            time.sleep(1)  # 每秒检查一次更新
    except Exception as e:
        print(f"发生错误: {e}")
        for chat_id in CHAT_IDS:
            send_message(chat_id, "Bot 发生错误，已停止运行")
