resource "portainer_stack" "qbitorrent" {
  name            = "qbitorrent"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["deb"]

  stack_file_content = <<-EOT
    services:
      qbittorrent:
        image: lscr.io/linuxserver/qbittorrent
        container_name: qbittorrent
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Etc/UTC
          - WEBUI_PORT=8080
          - TORRENTING_PORT=6881
        volumes:
          - ${var.deb_volume_base_path}/serveur/qbittorrent/appdata:/config
          - ${var.deb_volume_base_path}/serveur/media:/downloads
          - ${var.deb_volume_base_path}/serveur/media/films:/films
          - ${var.deb_volume_base_path}/serveur/media/series:/series
          - ${var.deb_volume_base_path}/torrent:/torrent
          - ${var.deb_volume_base_path}/serveur/komga/data/manga:/manga
          - ${var.deb_volume_base_path}/serveur/komga/data/comics:/comics
        ports:
          - 8085:8080
          - 6881:6881
          - 6881:6881/udp
        restart: unless-stopped  
  EOT
}
