import os


def try_parse(type, value: str):
    try:
        return type(value)
    except Exception:
        return None


STORE_HOST = os.environ.get("STORE_API_HOST") or "localhost"
STORE_PORT = try_parse(int, os.environ.get("STORE_API_PORT")) or 8000
