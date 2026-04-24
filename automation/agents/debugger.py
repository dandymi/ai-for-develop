from mcp_client import read_file, write_file

def debugger_agent(error, repo, file_path, llm):
    file_data = read_file(repo, file_path)

    prompt = f"""
    Fix error:

    {error}

    CODE:
    {file_data.get("content", "")}
    """

    fixed = llm.invoke(prompt).content

    write_file(repo, file_path, fixed)
