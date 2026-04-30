resource "portainer_stack" "reverse-proxy" {
  name            = "reverse-proxy"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["pi"]

  stack_file_content = <<-EOT
    services:
      proxy:
        image: docker.io/jc21/nginx-proxy-manager:latest
        restart: unless-stopped
        container_name: proxy
        volumes:
          - ${var.pi_volume_base_path}/proxy/data:/data
          - ${var.pi_volume_base_path}/proxy/letsencrypt:/etc/letsencrypt
        ports:
          - '80:80'
          - '81:81'
          - '443:443'
        networks:
          - proxy

    networks:
      proxy:
        external: true
  EOT
}
