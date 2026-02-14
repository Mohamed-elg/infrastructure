resource "portainer_stack" "smb" {
  name            = "smb"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.environment["deb"]

  stack_file_content = <<-EOT
    services:
      samba:
        image: dockurr/samba
        container_name: samba
        environment:
          NAME: "${var.smb.name}"
          USER: "${var.smb.user}"
          PASS: "${var.smb.pass}"
        ports:
          - 445:445
        volumes:
          - ${var.deb_volume_base_path}:/storage
        restart: always 
  EOT
}
