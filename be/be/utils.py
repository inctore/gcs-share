import os


def get_port() -> int:
    ret = os.getenv("PORT", 9345)
    return int(ret)
