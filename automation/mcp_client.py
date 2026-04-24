import requests

BASE = "http://localhost:3000"

def read_file(repo, path):
    return requests.post(f"{BASE}/read-file", json={
        "repo": repo,
        "path": path
    }).json()

def write_file(repo, path, content):
    return requests.post(f"{BASE}/write-file", json={
        "repo": repo,
        "path": path,
        "content": content
    }).json()

def run_tests(repo):
    return requests.post(f"{BASE}/run-tests", json={
        "repo": repo
    }).json()
