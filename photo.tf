resource "portainer_stack" "photo" {
  name            = "photo"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["deb"]

  stack_file_content = <<-EOT
    services:
      immich-server:
        container_name: immich_server
        image: ghcr.io/immich-app/immich-server:release
        volumes:
          - ${var.deb_volume_base_path}/photos:/data
          - /etc/localtime:/etc/localtime:ro
        environment:
          TZ: Europe/Paris
          IMMICH_VERSION: release
          DB_PASSWORD: ${var.postgre.pass}
          DB_USERNAME: ${var.postgre.user}
          DB_DATABASE_NAME: ${var.postgre.db}
        ports:
          - 2283:2283
        depends_on:
          - redis
          - database
        restart: always
        healthcheck:
          disable: false

      redis:
        container_name: immich_redis
        image: docker.io/valkey/valkey:8-bookworm@sha256:fea8b3e67b15729d4bb70589eb03367bab9ad1ee89c876f54327fc7c6e618571
        healthcheck:
          test: redis-cli ping || exit 1
        restart: always

      database:
        container_name: immich_postgres
        image: ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23
        environment:
          POSTGRES_PASSWORD: ${var.postgre.pass}
          POSTGRES_USER: ${var.postgre.user}
          POSTGRES_DB: ${var.postgre.db}
          POSTGRES_INITDB_ARGS: '--data-checksums'
          # Uncomment the DB_STORAGE_TYPE: 'HDD' var if your database isn't stored on SSDs
          DB_STORAGE_TYPE: 'HDD'
        volumes:
          - ${var.deb_volume_base_path}/serveur/immich/db:/var/lib/postgresql/data
        shm_size: 128mb
        restart: always
  EOT
}
