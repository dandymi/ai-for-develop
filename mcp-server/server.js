const express = require("express");
const fs = require("fs");
const { exec } = require("child_process");

const app = express();
app.use(express.json());

const ROOT = "/workspace/projects";

function resolve(repo, path) {
  return `${ROOT}/${repo}/${path}`;
}

app.post("/read-file", (req, res) => {
  try {
    const { repo, path } = req.body;
    const content = fs.readFileSync(resolve(repo, path), "utf-8");
    res.json({ success: true, content });
  } catch (e) {
    res.json({ success: false, error: e.message });
  }
});

app.post("/write-file", (req, res) => {
  try {
    const { repo, path, content } = req.body;
    fs.writeFileSync(resolve(repo, path), content);
    res.json({ success: true });
  } catch (e) {
    res.json({ success: false, error: e.message });
  }
});

app.post("/run-tests", (req, res) => {
  const { repo } = req.body;

  exec(`cd ${ROOT}/${repo} && pytest`, (err, stdout, stderr) => {
    res.json({
      success: !err,
      output: stdout + stderr
    });
  });
});

app.listen(3000, () => console.log("MCP running"));
