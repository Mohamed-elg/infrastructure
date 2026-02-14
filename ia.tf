resource "portainer_stack" "ia" {
  name            = "ia"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["deb"]

  stack_file_content = <<-EOT
    services:
      ollama:
        image: ollama/ollama
        container_name: ollama
        environment:
          - PUID=1000
          - PGID=1000
          - ENABLE_IMAGE_GENERATION=True      
          - NVIDIA_VISIBLE_DEVICES=all
          - NVIDIA_DRIVER_CAPABILITIES=compute,utility
          - OLLAMA_ACCELERATE=1
        ports:
          - "11434:11434"
        volumes:
          - ${var.deb_volume_base_path}/serveur/ia/ollama:/root/.ollama
        restart: unless-stopped
        deploy:
          resources:
            reservations:
              devices:
                - driver: nvidia
                  count: 1
                  capabilities: [gpu]
      comfy:
        image: fredmei/sd-comfy
        container_name: comfy
        restart: unless-stopped
        ports:
          - "7860:7860"
        volumes:
          - ${var.deb_volume_base_path}/serveur/ia/comfy/data:/data
          - ${var.deb_volume_base_path}/serveur/ia/comfy/output:/output/comfy

        stop_signal: SIGINT
        tty: true
        environment:
          - PUID=1000
          - PGID=1000
          - CLI_ARGS=

      open-webui:
        image: ghcr.io/open-webui/open-webui:main
        container_name: open-webui
        restart: unless-stopped
        ports:
          - "8282:8080"
        volumes:
          - ${var.deb_volume_base_path}/serveur/ia/web:/app/backend/data
        depends_on:
          - ollama
          - comfy
        environment:
          - PUID=1000
          - PGID=1000
          - OLLAMA_BASE_URL=http://ollama:11434
          - WEBUI_SECRET_KEY=
          - ENABLE_RAG_WEB_SEARCH=True
          - RAG_WEB_SEARCH_ENGINE=searxng
          - RAG_WEB_SEARCH_RESULT_COUNT=3
          - RAG_WEB_SEARCH_CONCURRENT_REQUESTS=10
          # - SEARXNG_QUERY_URL=http://searxng:8080/search?q=<query>

      faster-whisper:
        image: lscr.io/linuxserver/faster-whisper:latest
        container_name: faster-whisper
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Etc/UTC
          - WHISPER_MODEL=small
          - WHISPER_BEAM=1 #optional
          - WHISPER_LANG=fr #optional
        volumes:
          - ${var.deb_volume_base_path}/serveur/ia/faster-whisper/data:/config
        ports:
          - 10300:10300
        restart: unless-stopped

      piper:
        image: lscr.io/linuxserver/piper:latest
        container_name: piper
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Paris
          - PIPER_VOICE=fr_FR-tom-medium
          - PIPER_LENGTH=1.0 #optional
          - PIPER_NOISE=0.667 #optional
          - PIPER_NOISEW=0.333 #optional
          - PIPER_SPEAKER=0 #optional
          - PIPER_PROCS=1 #optional
        volumes:
          - ${var.deb_volume_base_path}/serveur/ia/piper/data:/config
        ports:
          - 10200:10200
        restart: unless-stopped
  EOT
}
