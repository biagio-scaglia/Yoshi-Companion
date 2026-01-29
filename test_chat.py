import requests
import json
import sys


def test_chat(message):
    url = "http://127.0.0.1:8000/chat"
    headers = {"Content-Type": "application/json"}
    data = {"message": message}

    print(f"🦖 Sending to Yoshi: '{message}'...")
    try:
        with requests.post(url, json=data, headers=headers, stream=True) as response:
            if response.status_code == 200:
                print("💚 Yoshi says: ", end="", flush=True)
                for chunk in response.iter_content(chunk_size=None):
                    if chunk:
                        print(chunk.decode("utf-8"), end="", flush=True)
                print("\n")
            else:
                print(f"❌ Error: {response.status_code} - {response.text}")
    except Exception as e:
        print(f"❌ Connection Error: {e}")
        print(
            "Make sure the backend is running! (venv\\Scripts\\uvicorn backend.main:app --reload)"
        )


if __name__ == "__main__":
    msg = "I am feeling a bit sad today."
    if len(sys.argv) > 1:
        msg = " ".join(sys.argv[1:])
    test_chat(msg)
