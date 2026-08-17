FROM python:3.11.9-slim-bookworm
WORKDIR /app
COPY hello.py .
CMD ["python", "hello.py"]
