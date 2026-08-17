job "hello" {
  datacenters = ["dc1"]
  type = "service"

  group "hello-group" {
    count = 1

    task "hello" {
      driver = "docker"

      config {
        image      = "devops-hello:1.0.0"
        force_pull = false
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
