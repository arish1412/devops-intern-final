# DevOps Intern Final - Workflow Demo

**Author:** arish1412

**Repository:** https://github.com/arish1412/devops-intern-final

**Date:** 2026-08-12

This project demonstrates a small DevOps workflow: source control, a GitHub Actions check, a pinned Docker image, a Nomad job, and Loki log collection through Promtail.

CI status: ![CI](https://github.com/arish1412/devops-intern-final/actions/workflows/ci.yml/badge.svg)

## Repository Contents

- `hello.py` - prints the application message: `Hello, DevOps!`
- `Dockerfile` - builds the app on the pinned base image `python:3.11.9-slim-bookworm`
- `.github/workflows/ci.yml` - runs the app in GitHub Actions with Python `3.11.9`
- `nomad/hello.nomad` - runs the pinned app image `devops-hello:1.0.0`
- `monitoring/docker-compose.yml` - starts Loki and Promtail with pinned Grafana image tags
- `monitoring/loki-config.yml` - single-node Loki filesystem configuration
- `monitoring/promtail-config.yml` - scrapes Nomad allocation logs and Docker container logs into Loki
- `scripts/sysinfo.sh` - prints basic Linux host information
- `.gitignore` - excludes local Python, Docker, editor, and Nomad state

## 1. Git History

The repository remote is configured for the submitted GitHub repo:

```bash
git remote -v
```

Expected output:

```text
origin  https://github.com/arish1412/devops-intern-final.git (fetch)
origin  https://github.com/arish1412/devops-intern-final.git (push)
```

Check the commit history before resubmitting:

```bash
git log --oneline --decorate --max-count 8
```

The current local history before this cleanup was:

```text
938bd2c (HEAD -> main, origin/main, origin/HEAD) Update README with actual GitHub repo info
808ce4e Merge remote initial commit
2027b28 Initial commit
87ce634 Add DevOps workflow project
```

Screenshot to include: `docs/screenshots/01-git-history.png`

## 2. Run the App Locally

Run the Python app directly:

```bash
python hello.py
```

Expected output:

```text
Hello, DevOps!
```

On Linux, the host-info script can also be checked:

```bash
chmod +x scripts/sysinfo.sh
./scripts/sysinfo.sh
```

## 3. Build and Run the Docker Image

The image tag is pinned to `devops-hello:1.0.0`; no floating tag is used.

```bash
docker build -t devops-hello:1.0.0 .
docker run --rm --name devops-hello devops-hello:1.0.0
```

Expected application output:

```text
Hello, DevOps!
```

Screenshot to include: `docs/screenshots/02-docker-build-run.png`

## 4. GitHub Actions

The workflow at `.github/workflows/ci.yml` runs automatically on every push. It checks out the repo, installs Python `3.11.9`, and runs:

```bash
python hello.py
```

After pushing the cleanup commit, verify the run at:

```text
https://github.com/arish1412/devops-intern-final/actions/workflows/ci.yml
```

Screenshot to include: `docs/screenshots/03-github-actions.png`

## 5. Run with Nomad

Prerequisites on the Nomad host:

- Docker installed and running
- Nomad installed
- A local Nomad dev agent or a reachable Nomad cluster

For a single-node local demo, start Nomad in dev mode:

```bash
sudo nomad agent -dev -bind=0.0.0.0 -data-dir=/opt/nomad/data
```

Build the pinned image on the same host that will run the Nomad Docker task:

```bash
docker build -t devops-hello:1.0.0 .
docker image inspect devops-hello:1.0.0 --format '{{.RepoTags}}'
```

Submit the job:

```bash
nomad job run nomad/hello.nomad
```

Verify that the job started and that the allocation completed:

```bash
nomad job status hello
nomad alloc status $(nomad job allocs -json hello | jq -r '.[0].ID')
```

Read the app logs from the allocation:

```bash
nomad alloc logs $(nomad job allocs -json hello | jq -r '.[0].ID') hello
```

Expected application log:

```text
Hello, DevOps!
```

Screenshots to include:

- `docs/screenshots/04-nomad-status.png`
- `docs/screenshots/05-nomad-logs.png`

## 6. Collect Logs with Loki

This repo now includes an actual log collection agent. `monitoring/docker-compose.yml` starts:

- Loki `grafana/loki:2.9.8`
- Promtail `grafana/promtail:2.9.8`

Promtail scrapes:

- Nomad allocation stdout logs from `/opt/nomad/data/alloc`
- Nomad allocation stderr logs from `/opt/nomad/data/alloc`
- Docker JSON logs from `/var/lib/docker/containers`

Start Loki and Promtail from the repo root on the Nomad host:

```bash
docker compose -f monitoring/docker-compose.yml up -d
docker compose -f monitoring/docker-compose.yml ps
```

After the Nomad job has run, query Loki for the app log:

```bash
docker run --rm --network monitoring_default grafana/logcli:2.9.8 \
  --addr=http://loki:3100 query '{job="nomad"}' --limit=20
```

Expected query result includes:

```text
Hello, DevOps!
```

Screenshot to include: `docs/screenshots/06-loki-query.png`

## 7. Resubmission Checklist

- README is a full walkthrough with concrete commands and expected output.
- Repository URL is `https://github.com/arish1412/devops-intern-final`.
- Docker base image is pinned to `python:3.11.9-slim-bookworm`.
- App image is pinned to `devops-hello:1.0.0`.
- Loki and Promtail images are pinned to `2.9.8`.
- Promtail is configured to ingest Nomad and Docker logs into Loki.
- Nomad verification includes `nomad job status`, `nomad alloc status`, and `nomad alloc logs`.
- Screenshot filenames are listed in `docs/screenshots/README.md` for final evidence capture.
- `.gitignore` is included.
