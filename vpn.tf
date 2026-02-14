resource "portainer_stack" "vpn" {
  name            = "vpn"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["pi"]

  stack_file_content = <<-EOT
    services:
      wg-easy:
        image: ghcr.io/wg-easy/wg-easy
        container_name: wg-easy
        environment:
          - PORT=5000
          - WG_HOST="${var.ip}"
          - WG_DEFAULT_DNS=10.8.0.1
          - INSECURE=true
        volumes:
          - ${var.pi_volume_base_path}/wireguard:/etc/wireguard
          - /lib/modules:/lib/modules:ro
        network_mode: "host"
        ports:
          - "51820:51820/udp"
          - "5000:5000/tcp"
        restart: unless-stopped
        cap_add:
          - NET_ADMIN
          - SYS_MODULE
  EOT
}
