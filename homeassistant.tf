resource "portainer_stack" "homeassistant" {
  name            = "homeassistant"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["pi"]

  stack_file_content = <<-EOT
	services:
	  homeassistant:
      image: lscr.io/linuxserver/homeassistant:latest
      container_name: homeassistant
      environment:
        - PUID=1000
        - PGID=1000
        - TZ=Europe/Paris
      volumes:
        - ${var.pi_volume_base_path}/homeassistant/scripts:/scripts
        - ${var.pi_volume_base_path}/homeassistant/config:/config
        - /run/dbus:/run/dbus:ro
        - /sys:/sys:ro
        - /var/run/docker.sock:/var/run/docker.sock:ro
      devices:
        - /dev/ttyUSB0:/dev/ttyUSB0
      cap_add:
        - NET_ADMIN
        - NET_RAW
      # ports:
      #   - 8123:8123
      network_mode: host
      restart: always
  EOT
}
