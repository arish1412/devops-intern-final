# DevOps Intern Final — DevOps Workflow Demo

**Author:** Your Name

**Date:** 2026-08-12

Project demonstrating a compact DevOps pipeline using Git, Docker, GitHub Actions, Nomad, and Loki. Follow the sections below to run each step locally and push to GitHub.

Contents
- **scripts/**: `sysinfo.sh` — simple Linux info script
- `hello.py`: sample app prints "Hello, DevOps!"
- `Dockerfile`: containerize `hello.py`
- `.github/workflows/ci.yml`: CI workflow that runs `python hello.py` on push
- `nomad/hello.nomad`: Nomad job to run the container
- `monitoring/loki_setup.txt`: notes to run Loki locally and view logs

Quick start

1. Initialize git and push to GitHub (create a new public repo, e.g. `devops-intern-final`):

```bash
git init
git add .
git commit -m "Initial commit: DevOps workflow demo"
# Create a repo on GitHub and follow its instructions to push, e.g.: 
# git remote add origin https://github.com/<your-user>/devops-intern-final.git
# git branch -M main
# git push -u origin main
```

2. Docker build & run (local):

```bash
docker build -t devops-hello:latest .
docker run --rm devops-hello:latest
```

3. GitHub Actions: After pushing the repo, CI will run automatically. Update the CI badge below with your GitHub owner/repo.

CI status: ![CI](https://github.com/<owner>/<repo>/actions/workflows/ci.yml/badge.svg)

4. Nomad: See `nomad/hello.nomad` for a job definition. To run locally (with Nomad + Docker installed):

```bash
# Build and tag image, then either push to a registry or load into the Nomad host
docker build -t <registry-or-host>/devops-hello:latest .
# Push to registry (optional)
docker push <registry-or-host>/devops-hello:latest
# Run the Nomad job
nomad job run nomad/hello.nomad
```

5. Loki monitoring: See `monitoring/loki_setup.txt` for starting Loki via Docker and viewing logs.

Notes
- Replace placeholders like `<owner>/<repo>` and `<registry-or-host>` with your values.
- Make `scripts/sysinfo.sh` executable before running: `chmod +x scripts/sysinfo.sh`

--
Minimal deliverables included in this repo; follow each section below for details.
