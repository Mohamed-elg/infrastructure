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
      cloudflared:
        image: cloudflare/cloudflared:latest
        container_name: cloudflared
        command: proxy-dns
        environment:
          - TUNNEL_DNS_UPSTREAM=https://1.1.1.1/dns-query
          - TUNNEL_DNS_PORT=5053
          - TUNNEL_DNS_ADDRESS=0.0.0.0
        network_mode: host
        ports:
          - 5053:5053/tcp
          - 5053:5053/udp
        restart: unless-stopped
  EOT
}
