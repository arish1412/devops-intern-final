# Screenshots to Attach Before Resubmission

Capture these after running the commands in the main README on the Nomad host:

1. `01-git-history.png` - `git log --oneline --decorate --max-count 8`
2. `02-docker-build-run.png` - `docker build ...` and `docker run ...`
3. `03-github-actions.png` - successful GitHub Actions workflow page
4. `04-nomad-status.png` - `nomad job status hello` and `nomad alloc status ...`
5. `05-nomad-logs.png` - `nomad alloc logs ...`
6. `06-loki-query.png` - Loki query returning the `Hello, DevOps!` log line
