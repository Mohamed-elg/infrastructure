resource "portainer_stack" "pihole" {
  name            = "pihole"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["pi"]

  stack_file_content = <<-EOT
    services:
      pihole:
        container_name: pihole
        image: pihole/pihole:latest
        ports:
          - 53:53/tcp
          - 53:53/udp
          - 82:80/tcp
        environment:
          TZ: 'Europe/Paris'
          FTLCONF_webserver_api_password: '${var.web_password}'
        volumes:
          - ${var.pi_volume_base_path}/etc-pihole:/etc/pihole
        restart: unless-stopped
  EOT
}
