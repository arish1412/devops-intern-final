job "hello" {
  datacenters = ["dc1"]
  type = "service"

  group "hello-group" {
    task "hello" {
      driver = "docker"

      config {
        image = "devops-hello:latest"
      }

      resources {
        cpu    = 100
        memory = 64
      }

      logs {
        max_files = 1
        max_file_size_mb = 5
      }
    }
  }
}
