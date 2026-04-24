from mcp_client import read_file, write_file
from memory.memory import search_memory

def backend_agent(task, repo, file_path, llm):
    file_data = read_file(repo, file_path)

    memory_hits = search_memory(task)

    context = "\n".join([m["solution"] for m in memory_hits[:2]])

    prompt = f"""
    TASK:
    {task}

    MEMORY:
    {context}

    CODE:
    {file_data.get("content", "")}

    Return updated code only.
    """

    response = llm.invoke(prompt).content

    write_file(repo, file_path, response)

    return response
