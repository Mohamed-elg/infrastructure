resource "portainer_stack" "arr" {
  name            = "arr"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["deb"]

  stack_file_content = <<-EOT
    version: "3.9"
    services:
      prowlarr:
        container_name: prowlarr
        restart: unless-stopped
        image: lscr.io/linuxserver/prowlarr:latest
        ports:
          - 9696:9696
        environment:
          - PUID=1000
          - PGID=1000
          - UMASK=002
          - TZ=Europe/Paris
        volumes:
          - ${var.deb_volume_base_path}/serveur/prowlarr:/config
      radarr:
        image: lscr.io/linuxserver/radarr:latest
        container_name: radarr
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Paris
        volumes:
          - ${var.deb_volume_base_path}/serveur/radarr:/config
          - ${var.deb_volume_base_path}/serveur/media/films:/movies
          - ${var.deb_volume_base_path}/serveur/media/radarr:/downloads/radarr
          - ${var.deb_volume_base_path}/serveur/media:/downloads
        ports:
          - 7878:7878
        restart: unless-stopped

      sonarr:
        image: lscr.io/linuxserver/sonarr:latest
        container_name: sonarr
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Paris
        volumes:
          - ${var.deb_volume_base_path}/serveur/sonarr:/config
          - ${var.deb_volume_base_path}/serveur/media/series:/tv
          - ${var.deb_volume_base_path}/serveur/media:/downloads
          - ${var.deb_volume_base_path}/serveur/media/series:/series
          - ${var.deb_volume_base_path}/serveur/media/sonarr:/downloads/sonarr
        networks:
          - default
        ports:
          - 8989:8989
        restart: unless-stopped  
  EOT
}
