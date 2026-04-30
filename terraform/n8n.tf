resource "portainer_stack" "n8n" {
  name            = "n8n"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["deb"]

  stack_file_content = <<-EOT
    services:
      n8n:
        image: n8nio/n8n
        container_name: n8n
        restart: always
        ports:
          - 5678:5678
        environment:
          - N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
          - N8N_HOST=n8n.pi
          - N8N_PORT=5678
          - N8N_PROTOCOL=http
          - N8N_RUNNERS_ENABLED=true
          - NODE_ENV=production
          - WEBHOOK_URL=http://n8n.pi/
          - TZ=Europe/Paris
          - N8N_SECURE_COOKIE=false
          - N8N_PROXY_HOPS=1
        volumes:
          - ${var.deb_volume_base_path}/serveur/n8n:/home/node/.n8n
          - ./local-files:/files
  EOT
}
