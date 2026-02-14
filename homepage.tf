resource "portainer_stack" "homepage" {
  name            = "homepage"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["pi"]

  stack_file_content = <<-EOT
    services:
      glance:
        container_name: glance
        image: glanceapp/glance
        restart: unless-stopped
        volumes:
          - ${var.pi_volume_base_path}/glance/config:/app/config
          - ${var.pi_volume_base_path}/glance/assets:/app/assets
          - /var/run/docker.sock:/var/run/docker.sock:ro
        ports:
          - 8080:8080
  EOT
}
