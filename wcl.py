"""Author tooling, never shipped (pkgmeta.yaml ignores it). Card 0064.

A small client for the Warcraft Logs v2 API (GraphQL, OAuth client credentials),
as docs/research/automated-build-sources.md describes it.

The client id and secret are read from .secrets/warcraftLogsClientSecrets.txt
(gitignored, never shipped), one "name: value" per line, or from the user
environment variables WCL_CLIENT_ID and WCL_CLIENT_SECRET. Nothing here prints
either value.

    python wcl.py probe     # token, rate limit, and the current zones
"""
import base64
import json
import os
import sys
import urllib.parse
import urllib.request

TOKEN_URL = "https://www.warcraftlogs.com/oauth/token"
API_URL = "https://www.warcraftlogs.com/api/v2/client"
SECRETS = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".secrets", "warcraftLogsClientSecrets.txt")


def credentials():
    """(client id, secret): the secrets file first, then the environment."""
    cid, secret = os.environ.get("WCL_CLIENT_ID"), os.environ.get("WCL_CLIENT_SECRET")
    if os.path.exists(SECRETS):
        with open(SECRETS, encoding="utf-8") as f:
            for line in f:
                name, sep, value = line.partition(":")
                if not sep:
                    continue
                name, value = name.strip().lower(), value.strip()
                if "secret" in name:
                    secret = value
                elif name.endswith("id"):
                    cid = value
    if not (cid and secret):
        sys.exit(f"No Warcraft Logs client id and secret: put them in {SECRETS} or WCL_CLIENT_ID / WCL_CLIENT_SECRET.")
    return cid, secret


_token = None


def token():
    global _token
    if _token:
        return _token
    cid, secret = credentials()
    basic = base64.b64encode(f"{cid}:{secret}".encode()).decode()
    req = urllib.request.Request(
        TOKEN_URL,
        data=urllib.parse.urlencode({"grant_type": "client_credentials"}).encode(),
        headers={"Authorization": "Basic " + basic, "Content-Type": "application/x-www-form-urlencoded"},
    )
    with urllib.request.urlopen(req, timeout=30) as r:
        _token = json.load(r)["access_token"]
    return _token


def query(text, variables=None):
    """Runs one GraphQL query. Exits on an error, printing the API's messages (never the key)."""
    req = urllib.request.Request(
        API_URL,
        data=json.dumps({"query": text, "variables": variables or {}}).encode(),
        headers={"Authorization": "Bearer " + token(), "Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            body = json.load(r)
    except urllib.error.HTTPError as e:
        sys.exit(f"Warcraft Logs answered {e.code}: {e.read()[:500]!r}")
    if body.get("errors"):
        sys.exit("Warcraft Logs errors: " + json.dumps(body["errors"])[:2000])
    return body["data"]


def probe():
    data = query("""{
      rateLimitData { limitPerHour pointsSpentThisHour pointsResetIn }
      worldData { expansions { id name zones { id name frozen difficulties { id name } encounters { id name } } } }
    }""")
    print(json.dumps(data["rateLimitData"]))
    for exp in data["worldData"]["expansions"][:1]:
        print(exp["id"], exp["name"])
        for z in exp["zones"]:
            print("  zone", z["id"], z["name"], "frozen" if z["frozen"] else "",
                  [d["name"] + "=" + str(d["id"]) for d in z["difficulties"] or []])
            for e in z["encounters"] or []:
                print("    ", e["id"], e["name"])


if __name__ == "__main__":
    if sys.argv[1:] == ["probe"]:
        probe()
    else:
        print(__doc__)
