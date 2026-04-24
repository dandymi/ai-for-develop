from agents.backend_agent import backend_agent
from agents.debugger import debugger_agent
from mcp_client import run_tests
from memory.memory import store_solution
from config import MAX_ITER

def run_pipeline(task, repo, file_path, llm):
    for i in range(MAX_ITER):
        print(f"Iteration {i}")

        code = backend_agent(task, repo, file_path, llm)

        test_result = run_tests(repo)

        if test_result["success"]:
            print("✅ Success")
            store_solution(task, code)
            break
        else:
            print("❌ Fixing...")
            debugger_agent(test_result["output"], repo, file_path, llm)
