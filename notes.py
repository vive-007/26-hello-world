"""Read/write the same private_notes table the web app uses.

Setup (local only, never committed):
  1. copy .env.example to .env
  2. put your Supabase password in .env
  3. python notes.py list
     python notes.py add "buy milk"
"""
import os
import sys

import requests
from dotenv import load_dotenv

load_dotenv()

URL = os.environ.get("SUPABASE_URL", "https://wvtdntsyncjvovvrxktw.supabase.co")
KEY = os.environ.get("SUPABASE_PUBLISHABLE_KEY", "sb_publishable_iw2WE40zKKOr89394OEPfQ_2L-fDyRy")
EMAIL = os.environ.get("NOTES_EMAIL", "")
PASSWORD = os.environ.get("NOTES_PASSWORD", "")


def login() -> str:
    if not EMAIL or not PASSWORD:
        raise SystemExit("Missing NOTES_EMAIL / NOTES_PASSWORD — copy .env.example to .env and fill it in.")
    r = requests.post(
        f"{URL}/auth/v1/token?grant_type=password",
        headers={"apikey": KEY, "Content-Type": "application/json"},
        json={"email": EMAIL, "password": PASSWORD},
        timeout=20,
    )
    r.raise_for_status()
    return r.json()["access_token"]


def list_notes(token: str) -> None:
    r = requests.get(
        f"{URL}/rest/v1/private_notes?select=content,created_at&order=created_at.desc",
        headers={"apikey": KEY, "Authorization": f"Bearer {token}"},
        timeout=20,
    )
    r.raise_for_status()
    rows = r.json()
    if not rows:
        print("(no notes yet)")
        return
    for row in rows:
        print(f"- {row['content']} ({row['created_at']})")


def add_note(token: str, text: str) -> None:
    r = requests.post(
        f"{URL}/rest/v1/private_notes",
        headers={"apikey": KEY, "Authorization": f"Bearer {token}", "Content-Type": "application/json"},
        json={"content": text},
        timeout=20,
    )
    r.raise_for_status()
    print("saved.")


def main(argv: list) -> None:
    token = login()
    if len(argv) >= 2 and argv[1] == "add":
        text = " ".join(argv[2:]).strip()
        if not text:
            raise SystemExit('usage: python notes.py add "note text"')
        add_note(token, text)
    else:
        list_notes(token)


if __name__ == "__main__":
    main(sys.argv)
