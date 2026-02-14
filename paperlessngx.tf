resource "portainer_stack" "paperlessngx" {
  name            = "paperlessngx"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["deb"]

  stack_file_content = <<-EOT
	services:
	  broker:
      image: docker.io/library/redis:8
      restart: unless-stopped
      volumes:
        - redisdata:/data
	  webserver:
      image: ghcr.io/paperless-ngx/paperless-ngx:latest
      restart: unless-stopped
      depends_on:
        - broker
        - gotenberg
        - tika
      ports:
        - "8000:8000"
      volumes:
        - ${var.deb_volume_base_path}/serveur/paperless/data:/usr/src/paperless/data
        - ${var.deb_volume_base_path}/serveur/paperless/media:/usr/src/paperless/media
        - ./export:/usr/src/paperless/export
        - ./consume:/usr/src/paperless/consume
      environment:
        PAPERLESS_TIME_ZONE: Europe/Paris
        PAPERLESS_REDIS: redis://broker:6379
        PAPERLESS_TIKA_ENABLED: 1
        PAPERLESS_TIKA_GOTENBERG_ENDPOINT: http://gotenberg:3000
        PAPERLESS_TIKA_ENDPOINT: http://tika:9998
        PAPERLESS_OCR_LANGUAGE: fra
        PAPERLESS_URL: http://docs.pi
        PAPERLESS_SECRET_KEY: ${var.web_password}
        PAPERLESS_IGNORE_DUPLICATES: true
	  gotenberg:
      image: docker.io/gotenberg/gotenberg:8.22
      restart: unless-stopped
      # The gotenberg chromium route is used to convert .eml files. We do not
      # want to allow external content like tracking pixels or even javascript.
      command:
        - "gotenberg"
        - "--chromium-disable-javascript=true"
        - "--chromium-allow-list=file:///tmp/.*"
	  tika:
      image: docker.io/apache/tika:latest
      restart: unless-stopped
	volumes:
	  redisdata:
  EOT
}

