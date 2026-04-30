resource "portainer_stack" "ntfy" {
  name            = "ntfy"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["pi"]

  stack_file_content = <<-EOT
    services:
      ntfy:
        image: binwiederhier/ntfy
        container_name: ntfy
        command:
          - serve
        environment:
          - TZ=UTC+2
        user: 1000:1000
        ports:
          - 84:80
        restart: unless-stopped
        networks:
          - proxy

    networks:
      proxy:
        external: true
  EOT
}
