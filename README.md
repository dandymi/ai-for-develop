# ai-for-develop
An ai agent coding setup for my works

ai-dev-platform/
│
├── .ai/
│   ├── agents/
│   ├── prompts/
│   ├── workflows/
│   ├── memory/
│   └── tasks/
│
├── automation/
│   ├── agents/
│   ├── tools/
│   ├── memory/
│   ├── main.py
│   ├── mcp_client.py
│   └── config.py
│
├── mcp-server/
│   ├── server.js
│   ├── package.json
│   └── Dockerfile
│
├── dashboard/
│   └── (React app)
│
├── projects/
│   └── example-app/
│       ├── src/
│       ├── tests/
│       └── Dockerfile
│
├── infra/
│   ├── docker-compose.yml
│   └── k8s/
│
├── docs/
│   ├── architecture.md
│   ├── agents.md
│   ├── mcp.md
│   ├── memory.md
│   └── workflows.md
│
├── .env.example
├── README.md
└── requirements.txt

🚀 7) HOW TO START (IMPORTANT)
Step 1
docker-compose up

Step 2

Start automation:
python automation/main.py

Step 3

Use Visual Studio Code + Continue.dev to:
create tasks
inspect results
refine prompts

---------------------------

# AI Dev Platform

## Start

docker-compose up

## Run automation

python automation/main.py

## Open in VS Code

Use Continue extension to interact with agents.

# HOW TO USE (real workflow)

## Step 1

docker-compose up

## Step 2

curl localhost:8000/health

## Step 3

python automation/main.py

## Step 4

/build add new endpoint /users
/review this file

