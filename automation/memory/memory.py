import json

MEMORY_FILE = "automation/memory/store.json"

def load_memory():
    try:
        with open(MEMORY_FILE) as f:
            return json.load(f)
    except:
        return []

def save_memory(memory):
    with open(MEMORY_FILE, "w") as f:
        json.dump(memory, f, indent=2)

def search_memory(task):
    memory = load_memory()
    return [m for m in memory if any(k in task.lower() for k in m["context"])]

def store_solution(task, solution):
    memory = load_memory()

    memory.append({
        "problem": task,
        "solution": solution,
        "context": task.lower().split(),
        "score": 0.8
    })

    save_memory(memory)
