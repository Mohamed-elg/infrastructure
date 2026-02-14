resource "portainer_stack" "streaming" {
  name            = "streaming"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["deb"]

  stack_file_content = <<-EOT
    services:
      jellyfin:
        image: jellyfin/jellyfin
        container_name: jellyfin
        user: '1000'
        ports:
          - 8096:8096
          - 58096:58096
        volumes:
          - ${var.deb_volume_base_path}/serveur/jellyfin:/config
          - type: bind
            source: ${var.deb_volume_base_path}/serveur/media/films
            target: /films
          - type: bind
            source: ${var.deb_volume_base_path}/serveur/media/series
            target: /series
        restart: 'unless-stopped'
        # Optional - alternative address used for autodiscovery
        environment:
          - JELLYFIN_PublishedServerUrl=http://stream.pi
        # Optional - may be necessary for docker healthcheck to pass if running in host network mode
        # extra_hosts:
        #   - 'host.docker.internal:host-gateway' 
      jellyseerr:
        image: ghcr.io/fallenbagel/jellyseerr:latest
        init: true
        container_name: jellyseerr
        environment:
          - LOG_LEVEL=info
          - TZ=Europe/Paris
          - PORT=5055 #optional
        ports:
          - 5055:5055
        volumes:
          - ${var.deb_volume_base_path}/serveur/jellyseerr:/app/config
        healthcheck:
          test: wget --no-verbose --tries=1 --spider http://localhost:5055/api/v1/status || exit 1
          start_period: 20s
          timeout: 3s
          interval: 15s
          retries: 3
        restart: unless-stopped
  EOT
}
